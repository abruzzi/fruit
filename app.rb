require 'sinatra'
require 'rack/contrib'
require 'haml'
require 'json'

require 'net/ssh'
require 'YAML'

require 'logger'

module Sinatra
  module Broadcast
    def send_message(config, message)
      begin
        Net::SSH.start(config["host"], config["user"], :keys => config["key"], :timeout => 3) do |session|
          # session.exec!("say -v Ting-Ting #{message}")
          output = session.exec!("echo #{message}  #{config["host"]} #{config["desc"]}")
          puts output
        end        
      rescue Exception => e
        settings.logger.info(e.message)
      end
    end

    def get_certain_clients(regions)
      unless regions.empty?
        return settings.always_ons.select do |always_on|
          regions.include? always_on['desc']
        end 
      end

      settings.always_ons
    end
  end
end

class FruitApp < Sinatra::Application
  use Rack::PostBodyContentTypeParser
  
  use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == 'secret'
  end

  helpers Sinatra::Broadcast
  configure do
      set :bind, '0.0.0.0'
      set :logger, Logger.new('broadcast_log.log', 'monthly')
      set :always_ons, YAML.load_file('always-ons.yml')
  end

  before do
    content_type :json
  end

  not_found do
    {:message => "page not found"}.to_json
  end

  post '/broadcast' do
      message = params["message"]
      if message.empty?
          halt 400, {:message => "Bad Request"}.to_json
      end
      
      settings.logger.info("Got message #{message} from #{request.ip}")

      real_message, *regions = message.split('@').map(&:strip)
      clients = get_certain_clients(regions)

      threads = []
      clients.each do |always_on|
          threads << Thread.new do
              send_message(always_on, real_message)
          end
      end
      threads.map(&:join)

      {:message => real_message}.to_json
  end

  get '/broadcast' do
    content_type :html
    File.open("views/index.html")
  end

  get '/regions' do
    settings.always_ons.map do |always_on| 
      {
        :region => always_on["region"],
        :description => always_on["desc"]
      }
    end.to_json
  end

  get '/' do
    redirect '/broadcast'
  end

end
