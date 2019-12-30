require "./entities"
require "./tube_status"

module TFL
  class Checker
    BASE_URL = "https://api.tfl.gov.uk/line/mode/tube/status"

    def problems : Array(TubeStatus)
      response = HTTP::Client.get(BASE_URL)
      Array(LineInfo).from_json(response.body)
        .map { |status| TubeStatus.new(status) }
        .select { |status| !status.is_good? }
    end
  end
end
