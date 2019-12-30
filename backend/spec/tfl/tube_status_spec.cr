require "../spec_helper"

require "../../src/tfl/tube_status"

module TFL
  describe TubeStatus do
    describe "#line" do
      it "returns the line name" do
        status = TubeStatus.new(LineInfo.from_json(%({"id":"foo","lineStatuses":[{"statusSeverityDescription":"delay"}]})))
        status.line.should eq "foo"
      end
    end

    describe "#status" do
      it "returns the first line status" do
        status = TubeStatus.new(LineInfo.from_json(%({"id":"foo","lineStatuses":[{"statusSeverityDescription":"delay"}]})))
        status.status.should eq "delay"
      end
    end

    describe "#is_good?" do
      context "when the service is good" do
        it "returns true" do
          status = TubeStatus.new(LineInfo.from_json(%({"id":"foo","lineStatuses":[{"statusSeverityDescription":"Good Service"}]})))
          status.is_good?.should eq true
        end
      end

      context "when the service is broken" do
        it "returns false" do
          status = TubeStatus.new(LineInfo.from_json(%({"id":"foo","lineStatuses":[{"statusSeverityDescription":"Severe Delays"}]})))
          status.is_good?.should eq false
        end
      end
    end
  end
end
