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
        output = session.exec!("echo #{message}")
        puts output
      end
    end
  end
end

class FruitApp < Sinatra::Application
  use Rack::PostBodyContentTypeParser
  helpers Sinatra::Broadcast

  configure do
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
    settings.always_ons.each do |always_on|
      settings.logger.info("send message to #{always_on['host']}, message is #{message}")
      send_message(always_on, message)
    end
    {:message => message}.to_json
  end

  get '/' do
    content_type :html
    File.open("views/index.html")
  end
end
