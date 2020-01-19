class Fetcher(T)
  def fetch(url : String) : T
    response = HTTP::Client.get(url)
    T.from_json(response.body)
  end
end
