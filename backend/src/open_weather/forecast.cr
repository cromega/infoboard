module OpenWeather
  class Forecast
    def initialize(@forecast : ForecastEntry); end

    def icon : String
      @forecast.weather.first.icon
    end

    def to_json(json : JSON::Builder)
      ""
    end
  end
end
