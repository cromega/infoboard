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

