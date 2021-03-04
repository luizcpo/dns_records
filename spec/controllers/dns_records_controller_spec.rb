require 'rails_helper'

RSpec.describe DnsRecordsController, type: :request do
    # With due time I would like to do some factory with FactoryBot to avoid the following
    describe "GET #index" do
        before do
            if DnsRecord.find_by_ip_address("1.1.1.1").nil?
                DnsRecord.create!(ip_address: '1.1.1.1', hostnames_attributes: [
                    { hostname: 'lorem.com' },
                    { hostname: 'ipsum.com' },
                    { hostname: 'dolor.com' },
                    { hostname: 'amet.com' }
                ])
            end
            params = {
                "hostnames": {
                    "should_have": ["ipsum.com" , "dolor.com"],
                    "shouldnt_have": ["sit.com"]
                },
                "page": 1
            }
            get "/dns_records", params: params, headers: {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
        end

        it "returns http success" do
            expect(response).to have_http_status(:success)
        end

        it "returns a JSON body response that contains expected recipe attributes" do
            json_response = JSON.parse(response.body)
            expect(json_response.keys).to match_array(["total_records", "records", "related_hostnames"])
        end
    end

    describe "POST #create" do
        before do
            params = {
                "dns_records": {
                    "ip": "7.7.7.7",
                    "hostnames_attributes": [
                        { "hostname": "anothenewone.com.br" },
                        { "hostname": "newone.com" }
                    ]
                }
            }
            post "/dns_records", params: params.to_json, headers: {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
        end

        it "creates a new dns_record with the params" do
            expect(response).to have_http_status(:success)
        end

        it "returns the id of the created dns_records" do
            json_response = JSON.parse(response.body)
            expect(json_response.keys).to match_array(["id"])
        end
    end
end
