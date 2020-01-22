class Fetcher(T)
  class FetchFailed < Exception; end

  def fetch(url : String) : T
    response = HTTP::Client.get(url)
    handle_failure(response) unless response.success?

    begin
      T.from_json(response.body)
    rescue e : JSON::MappingError
      puts "Failed to parse body as #{T.class}: #{response.body}"
      raise e
    end
  end

  private def handle_failure(response : HTTP::Client::Response) : Void
    puts "Failed to run request: #{response.body}"
    raise FetchFailed.new("boo") unless response.success?
  end
end
