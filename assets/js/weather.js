function Forecast(response) {
  var
    _getIconUrl = function(icon) {
      return "http://openweathermap.org/img/w/" + icon + ".png";
    },
    _getRainSummary = function(rain) {
      if (rain === undefined) { return "No rain"; }

      var rainmm = rain["3h"];
      var summary;
      if (rainmm < 0.1) {
        summary = "No rain";
      } else if (rainmm < 0.5) {
        summary = "Light rain";
      } else {
        summary = "Heavy rain"
      };
      return summary + " (" + (Math.round(rainmm * 100) / 100).toString() + "mm)";
    },
    _getWindSummary = function(wind) {
      if (wind === undefined) { return "No" }

      var kph = wind.speed * 3.6;
      return (Math.round(kph * 100) / 100).toString() + "kph";
    },
    _forecasts = response.list.slice(0, 4).map(function(forecast) {
      return {
        time: forecast.dt_txt.split(" ")[1].split(":").slice(0, 2).join(":"),
        temp: Math.round(forecast.main.temp) + "C",
        iconUrl: _getIconUrl(forecast.weather[0].icon),
        rain: _getRainSummary(forecast.rain),
        wind: _getWindSummary(forecast.wind),
      };
    });

  return {
    forecasts: _forecasts
  }
};

