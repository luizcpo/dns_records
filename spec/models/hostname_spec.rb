require 'rails_helper'

RSpec.describe Hostname, type: :model do
  it "is valid with hostname" do
    expect(Hostname.new(hostname:"teste.com")).to be_valid
  end

  it "is not valid without hostname" do
    expect(Hostname.new).to_not be_valid
  end
end
