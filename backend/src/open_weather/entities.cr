module OpenWeather
  class ForecastResponse
    JSON.mapping(
      list: Array(ForecastEntry)
    )
  end

  class ForecastEntry
    JSON.mapping(
      dt: Int64,
      main: ForecastMain,
      weather: Array(ForecastWeather),
      wind: ForecastWind,
      rain: ForecastRain?,
      snow: ForecastSnow?,
    )
  end

  class ForecastMain
    JSON.mapping(
      temp_min: Float64,
      temp_max: Float64,
    )
  end

  class ForecastWeather
    JSON.mapping(
      icon: String,
    )
  end

  class ForecastWind
    JSON.mapping(
      speed: Float64,
    )
  end

  class ForecastRain
    JSON.mapping(
      "h3": {type: Float64?, key: "3h"},
    )
  end

  class ForecastSnow
    JSON.mapping(
      "h3": {type: Float64?, key: "3h"},
    )
  end
end
