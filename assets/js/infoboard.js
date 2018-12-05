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

