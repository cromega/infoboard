require "./entities"
require "./tube_status"
require "../fetcher"

module TFL
  class Checker
    BASE_URL = "https://api.tfl.gov.uk/line/mode/tube/status"

    def problems : Array(TubeStatus)
      Fetcher(Array(StatusResponse)).new.fetch(BASE_URL)
        .map { |status| TubeStatus.new(status) }
        .select { |status| !status.is_good? }
    end
  end
end
