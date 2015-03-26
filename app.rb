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
      Net::SSH.start(config["host"], config["user"], :keys => config["key"]) do |session|
        # session.exec!("say -v Ting-Ting #{message}")
        output = session.exec!("echo #{message}  #{config["host"]}")
        puts output
      end
    end

    def get_certain_clients(floor)
      var client = Array.new
      settings.always_ons.each do |always_on|
        if (always_on['region'][/^#{floor}/])
          client.push always_on
        end
      end

    end
  end
end

class FruitApp < Sinatra::Application
  use Rack::PostBodyContentTypeParser
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

    post '/' do
        message = params["message"]
        
        if message.empty?
            halt 400, {:message => "Bad Request"}.to_json
        end

        threads = []

        settings.logger.info("Got message #{message} from #{request.ip}")
        settings.always_ons.each do |always_on|
            threads << Thread.new do
                send_message(always_on, message)
            end
        end
        threads.map(&:join)

        {:message => message}.to_json
    end

  get '/11' do
    content_type :html
    File.open("views/index.html")
  end

  post '/11' do
    message = params["message"]
    var clients = get_certain_clients(11)

    clients.each do |always_on|
      settings.logger.info("send message to #{always_on['host']}, message is #{message}")
      send_message(always_on, message)
    end
    {:message => message}.to_json
  end

end
