require 'sinatra'
require 'sinatra/respond_to'
require 'json'
require 'compass'

Sinatra::Application.register Sinatra::RespondTo

configure do
  # copied from https://github.com/chriseppstein/compass/wiki/Sinatra-Integration
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end

  set :haml, format: :html5
  set :sass, Compass.sass_engine_options
  set :scss, Compass.sass_engine_options
end

PROFILE_STR = File.read('./views/index.json').freeze
PROFILE_HSH = JSON.parse(PROFILE_STR).freeze

get '/stylesheets/application' do
  scss :application
end

get "/" do
  erb :index
end

get '/resume' do
  file = "public/images/Alexandra Siega - Resume.pdf"
  send_file(file, :disposition => 'attachment')
end

get "/api" do
  content_type :json
  File.read("views/index.json")
end

helpers do
  def to_html(val)
    case val
    when Array
      to_ul(val)
    when Hash
      to_dl(val)
    else
      val
    end
  end

  def to_dl(hash)
    out = "<dl>\n"
    hash.each do |key, val|
      out << "<dt>#{key}</dt>\n"
      dd = to_html(val)
      out << "<dd>#{dd}</dd>\n"
    end
    out << "</dl>\n"

    out
  end

  def to_ul(array)
    out = "<ul>\n"
    array.each do |item|
      li = to_html(item)
      out << "<li>#{li}</li>\n"
    end
    out << "</ul>\n"

    out
  end
end
