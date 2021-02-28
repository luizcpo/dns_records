class DnsRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @dns_records = DnsRecord.all
    records = []
    related_hostnames = []
    
    @dns_records.each do |dns|
      records.push(_json_dns_record(dns))
      related_hostnames.push(dns.hostnames.map{ |hostname| _json_hostname_record(hostname) })
    end

    @json = {
      total_records: @dns_records.size,
      records: records,
      related_hostnames: related_hostnames
    }
    
    render json: @json
  end

  def create
    content = JSON.parse(request.raw_post)
    
    attributes = {
      ip_address: content['dns_records']['ip'],
      hostnames_attributes: content['dns_records']['hostnames_attributes']
    }

    @dns_record = DnsRecord.create(attributes)

    render json: { id: @dns_record.id }
  end

  private

  def _json_dns_record(dns)
    {
      id: dns[:id],
      ip_address: dns[:ip_address]
    }
  end

  def _json_hostname_record(hostname)
    {
      hostname: hostname[:hostname],
      count: hostname.dns_records.size
    }
  end
end
