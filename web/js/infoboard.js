var Fetcher = function(config) {
  var _config = config,
      _cache = {};

  var _fetch = function(config) {
    fetch(config.url).
      then(response => response.json()).
      then(json => _cache[config.name] = json)
      .catch(err => console.log(err));

  };

  var _refresh = function() {
    config.forEach(entry => _fetch(entry));
  };

  var _get = function(name) {
    return _cache[name];
  }

  return {
    refresh: _refresh,
    get: _get,
  };
}

var Infoboard = function(container, config) {
  var _fetcher = new Fetcher(config);
  _fetcher.refresh();
  setInterval(function() {
    _fetcher.refresh();
  }, 600000);

  var templates = {};
  config.forEach(function(entry) {
    var source = document.getElementById(entry.template).innerHTML;
    templates[entry.name] = Handlebars.compile(source);
  });

  var _container = container;
  var _currentScreen = -1;

  var _nextScreen = function() {
    _currentScreen = (_currentScreen + 1) % config.length;
    var screenConfig = config[_currentScreen];
    _render(screenConfig);
  };

  var _render = function(screenConfig) {
    var data = _fetcher.get(screenConfig.name);
    var view = screenConfig.viewModel(data);
    _container.html(templates[screenConfig.name](view));
  };

  return {
    render: _render,
    nextScreen: _nextScreen,
  }
};

const config = [
  {
    name: "weather",
    template: "templates/forecast",
    url: `https://api.openweathermap.org/data/2.5/forecast?q=London,uk&mode=json&units=metric&appid=${GetOpenWeathermapApiKey()}`,
    viewModel: Forecast,
  },
  {
    name: "tube",
    template: "templates/tube-status",
    url: "https://api.tfl.gov.uk/line/mode/tube/status",
    viewModel: TubeAlerts
  }
];

u(document).on("DOMContentLoaded", function() {
  var app = new Infoboard(
    u("#app"),
    config
  );
  setTimeout(function() {
    app.nextScreen();
  }, 2000);
});

var OPENWEATHERMAP_API_KEY;
function GetOpenWeathermapApiKey() {
  return "dd0cd96d6c8616d74b5bcc30098db1a2";
};
function TubeAlerts(response) {
//var TubeAlerts = function(response) {
  var _getAlerts = function() {
    var affectedLines = response.filter(function(line) {
      return line.lineStatuses[0].statusSeverityDescription != "Good Service";
    });
    console.log(response);
    console.log(affectedLines);

    var alerts = affectedLines.map(function(line) {
      return {
        line: line.name,
        lineId: line.id,
        summary: line.lineStatuses[0].statusSeverityDescription
      };
    });

    return alerts;
  };

  return {
    alerts: _getAlerts()
  }
}
function Forecast(response) {
  console.log("bazmeg");
  console.log(response);
//var Forecast = function(response) {
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

