require 'sinatra'
require 'rack/contrib'
require 'haml'
require 'json'

class BottleApp < Sinatra::Application
    use Rack::PostBodyContentTypeParser 

    before do
        content_type :json
    end

    not_found do
        {:message => "page not found"}.to_json
    end

    post '/' do
        message = params["message"]
        {:message => message}.to_json
    end

    get '/' do
        content_type :html
        haml :index
    end
end
