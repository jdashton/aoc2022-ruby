# frozen_string_literal: true

RSpec.describe AoC2021::ArithmeticLogicUnit do
  it "finds the highest accepted model number" do
    expect(subject.max_num).to eq "91599994399395"
  end

  it "finds the lowest accepted model number" do
    expect(subject.min_num).to eq "71111591176151"
  end
end
