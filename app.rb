require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "eff06cd898db4a557b22d6ab451f9614"

get "/" do
    view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    lat = "#{lat_long[0]}"
    long = "#{lat_long[1]}"
    forecast = ForecastIO.forecast("#{lat}", "#{long}").to_hash
    current_temperature = forecast["currently"]["temperature"]
    conditions = forecast["currently"]["summary"]
    puts "In your city, it is currently #{current_temperature} and #{conditions}"
    #view "news"
end