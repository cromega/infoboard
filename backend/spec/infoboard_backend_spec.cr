require "./spec_helper"
require "webmock"

ENV["OPENWEATHERMAP_API_TOKEN"] = "token"

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

  describe "GET /weather" do
    before_each do
      WebMock.stub(:get, "https://api.openweathermap.org/data/2.5/forecast?mode=json&q=London,uk&units=metric&cnt=4&appid=token").
        to_return(body: File.read("spec/fixtures/openweathermap_response.json"))
    end

    it "responds with the 4 upcoming forecast entries" do
      get "/weather"
      data = JSON.parse(response.body)
      data.size.should eq 4
      data[0]["time"].should eq "12:00:00"
    end
  end
end
