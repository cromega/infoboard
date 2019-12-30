require "./forecast"
require "./entities"

module OpenWeather
  class Checker
    BASE_URL = "https://api.openweathermap.org/data/2.5/forecast"

    def forecast : Array(Forecast)
      params = HTTP::Params.encode({mode: "json", q: "London,uk", appid: token})
      response = HTTP::Client.get("#{BASE_URL}?#{params}")
      data = ForecastResponse.from_json(response.body)

      [] of Forecast

    end

    private def token : String
      ENV["OPENWEATHERMAP_API_TOKEN"]
    end
  end
end
