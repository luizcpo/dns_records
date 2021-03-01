require 'pagy'

class DnsRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    # TODO treat the json query
    content = JSON.parse(request.raw_post)

    records = []
    related_hostnames = []
  
    hostnames_should_have = content['hostnames']['should_have']
    hostnames_shouldnt_have = content['hostnames']['shouldnt_have']
    page_number = content['page']

    # Fetch the DNS Records related to the hostnames with the hostnames on the should have list
    if !hostnames_should_have.nil?
      dns_should_have = pagy(DnsRecord.with_related_hostnames(hostnames_should_have), page: page_number)
    else
      dns_should_have = pagy(DnsRecord.all, page: page_number)
    end

    # Fetch the DNS Records related to the hostnames with the hostnames on the shouldnt have list
    if !hostnames_shouldnt_have.nil?
      dns_shouldnt_have = pagy(DnsRecord.with_related_hostnames(hostnames_shouldnt_have), page: page_number)
    else
      dns_shouldnt_have = pagy(DnsRecord.all, page: page_number)
    end

    @dns_records = dns_should_have - dns_shouldnt_have
    
    # @dns_.each do |dns|
    #   records.push(_json_dns_record(dns))
    # end

    # @json = {
    #   total_records: @dns_.size,
    #   records: records,
    #   related_hostnames: related_hostnames
    # }
    render json: content
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
