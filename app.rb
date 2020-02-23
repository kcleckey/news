require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "eff06cd898db4a557b22d6ab451f9614"

#My News API key = 557a9b0c1cc1486496237c040e446961
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=557a9b0c1cc1486496237c040e446961"
news = HTTParty.get(url).parsed_response.to_hash
get "/" do
    view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])
    lat_long = results.first.coordinates # => [lat, long]
    lat = "#{lat_long[0]}"
    long = "#{lat_long[1]}"
    forecast = ForecastIO.forecast("#{lat}", "#{long}").to_hash
    @current_temp = forecast["currently"]["temperature"]
    @conditions = forecast["currently"]["summary"]    
    @dailyforecast = forecast["daily"]["data"]
    view "news"
end 