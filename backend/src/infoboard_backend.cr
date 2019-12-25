require "kemal"
require "./tube_checker"

module InfoboardBackend
  VERSION = "0.1.0"

  get "/status" do
    "OK"
  end

  get "/tube" do
    TubeChecker.new.problems.to_json
  end
end

Kemal.run
