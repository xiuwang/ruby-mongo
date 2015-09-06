require 'sinatra'
require_relative 'config/database'
require_relative 'models'

set :bind, '0.0.0.0'
set :port, 8080

def configure_database
  if ENV['RACK_ENV']=="production"
    while !self.connect_to_database_prod
      sleep 0.1
    end
  end
  puts "Connected to database"
  puts "Create database..."
end

configure do
  puts "Run app..."

  unless ENV["MONGODB_24_CENTOS7_SERVICE_HOST"].nil? && ENV["MONGODB_24_CENTOS7_PORT_27017_TCP_ADDR"].nil?
    configure_database
  end
end

get '/' do
  erb :main
end

get '/keys' do
  a={}
  KeyPair.all.each do |v|
    a[v.key]=v.value
  end
  a.to_s
end

get '/keys/:id' do
  if KeyPair.exists?(params[:id])
    KeyPair.find(params[:id]).value
  else
    not_found "Key not found"
  end
end

post '/keys/:id' do
  if KeyPair.exists?(params[:id])
    KeyPair.update(params['id'], value: params['value'])
    "Key updated"
  else
    KeyPair.create(key:params[:id],value:params['value']).save
    "Key created"
  end
end

delete '/keys/:id' do
  if KeyPair.exists?(params[:id])
    v=KeyPair.find(params[:id])
    v.destroy
    "Key deleted"
  else
    "Key not found"
  end
end
