require "./spec_helper"

require "../src/fetcher"

class ExampleEntity
  JSON.mapping data: Int64
end

describe Fetcher do
  before_each do
    WebMock.reset
  end

  describe "#fetch" do
    context "when there is a reponse" do
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

    context "when the request fails" do
      before_each do
        WebMock.stub(:get, "https://test.com").
          to_return(status: 401, body: "Forbidden")
      end

      it "raises an exception" do
        message = "Request to test.com failed: Forbidden"
        expect_raises(Fetcher::FetchFailed, message) do
          Fetcher(ExampleEntity).new.fetch("https://test.com")
        end
      end
    end
  end
end
