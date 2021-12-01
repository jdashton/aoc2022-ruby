# frozen_string_literal: true
require "spec_helper"

RSpec.describe AoC2021::SonarDepth do
  subject { AoC2021::SonarDepth.new([1, 3, 2]) }

  it "counts 1 increase for 1, 3, 2" do
    subject.count_increases.should == 1
  end
end
