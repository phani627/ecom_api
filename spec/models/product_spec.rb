require 'spec_helper'

describe Product do
  before { @product = FactoryGirl.build(:product) }

  subject { @product }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:price) }

  it { should be_valid }

end
