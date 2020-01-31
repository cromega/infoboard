module OpenWeather
  class Forecast
    def initialize(@forecast : ForecastEntry); end

    def time : String
      Time.unix(@forecast.dt).to_s("%H:%M")
    end

    def temp_min : Float64
      @forecast.main.temp_min
    end

    def temp_max : Float64
      @forecast.main.temp_max
    end

    def wind : Float64
      @forecast.wind.speed
    end

    def icon : String
      @forecast.weather.first.icon
    end

    def to_json(json : JSON::Builder)
      json.object do
        json.field "time", time
        json.field "temp_min", temp_min
        json.field "temp_max", temp_max
        json.field "icon", icon
      end
    end
  end
end
