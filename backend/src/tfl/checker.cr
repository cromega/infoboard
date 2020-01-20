require "./entities"
require "./tube_status"
require "../fetcher"

module TFL
  class Checker
    BASE_URL = "https://api.tfl.gov.uk/line/mode/tube/status"

    def initialize
      @fetcher = Fetcher(Array(StatusResponse)).new
    end

    def problems : Array(TubeStatus)
      @fetcher.fetch(BASE_URL)
        .map { |status| TubeStatus.new(status) }
        .select { |status| !status.is_good? }
    end
  end
end
