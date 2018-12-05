function TubeAlerts(response) {
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
