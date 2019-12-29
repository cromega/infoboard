require "./spec_helper"
require "webmock"

require "../src/infoboard_backend"

describe InfoboardBackend do
  describe "GET /status" do
    it "responds" do
      get "/status"
      response.body.should eq "OK"
    end
  end

  describe "GET /tube" do
    before_each do
      WebMock.stub(:get, "https://api.tfl.gov.uk/line/mode/tube/status").
        to_return(body: File.read("spec/fixtures/tfl_response.json"))
    end

    it "responds with the tube alerts" do
      get "/tube"
      response.body.should eq %([{\"line\":\"bakerloo\",\"status\":\"Minor Delays\"}])
    end
  end
end
