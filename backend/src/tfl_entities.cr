class TflLineInfo
  JSON.mapping(
    id: String,
    line_statuses: {type: Array(LineStatus), key: "lineStatuses"}
  )
end

class LineStatus
  JSON.mapping(
    status_severity_description: {type: String, key: "statusSeverityDescription"}
  )
end
