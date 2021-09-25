module Noodle::Web
  class Router < Hanami::API
    use Hanami::Middleware::BodyParser, :json

    get '/nodes/_/:search', to: Controllers::Query::Run.new
    post '/nodes/', to: Controllers::Noodlin::Run.new
  end
end
