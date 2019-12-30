module TFL
  class TubeStatus
    def initialize(@line_info : LineInfo); end

    def line : String
      @line_info.id
    end

    def status : String
      status_descriptions.first
    end

    def is_good? : Bool
      status_descriptions.first == "Good Service"
    end

    def to_json(json : JSON::Builder)
      json.object do
        json.field "line", line
        json.field "status", status
      end
    end

    private def status_descriptions
      @line_info.line_statuses.map { |status| status.status_severity_description }
    end
  end
end
