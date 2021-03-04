require 'rails_helper'

RSpec.describe DnsRecord, type: :model do
  it "is valid with ip_address" do
    expect(DnsRecord.new(ip_address: "1.1.1.2")).to be_valid
  end

  it "is not valid without an ip_address" do
    expect(DnsRecord.new).to_not be_valid
  end
end
