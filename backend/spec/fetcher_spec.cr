require "./spec_helper"

require "../src/fetcher"

class ExampleEntity
  JSON.mapping data: Int64
end

describe Fetcher do
  describe "#fetch" do
    before_each do
      WebMock.stub(:get, "https://test.com").
        to_return(body: %{{"data":123}})
    end

    it "fetches a response and parses it" do
      value = Fetcher(ExampleEntity).new.fetch("https://test.com")
      value.data.should eq 123
    end

    it "returns the parsed response as the generic type" do
      value = Fetcher(ExampleEntity).new.fetch("https://test.com")
      value.should be_a ExampleEntity
    end
  end
end
