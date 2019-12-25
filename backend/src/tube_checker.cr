require "./tfl_entities"

class TubeChecker
  BASE_URL = "https://api.tfl.gov.uk/line/mode/tube/status"

  def problems : Array(TflStatus)
    response = HTTP::Client.get(BASE_URL)
    Array(TflLineInfo).from_json(response.body)
      .map { |status| TflStatus.new(status) }
      .select { |status| !status.is_good? }
  end
end
