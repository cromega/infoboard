class Fetcher(T)
  class FetchFailed < Exception; end

  def fetch(url : String) : T
    response = HTTP::Client.get(url)
    handle_failure(url, response) unless response.success?

    begin
      T.from_json(response.body)
    rescue e : JSON::MappingError
      puts "Failed to parse body as #{T.class}: #{response.body}"
      raise e
    end
  end

  private def handle_failure(url, response)
    host = URI.parse(url).hostname
    raise FetchFailed.new("Request to #{host} failed: #{response.body}")# unless response.success?
  end
end
