class DnsRecordsController < ApplicationController
  include Pagy::Backend

  skip_before_action :verify_authenticity_token

  def index
    # TODO treat the json query
    content = JSON.parse(request.raw_post)

    related_hostnames = []
  
    hostnames_should_have = content['hostnames']['should_have']
    hostnames_shouldnt_have = content['hostnames']['shouldnt_have']
    page_number = content['page']
    dns_shouldnt_have = nil

    # Fetch the DNS Records related to the hostnames with the hostnames on the should have list
    if !hostnames_should_have.nil?
      @pagy, dns_should_have = pagy(DnsRecord.with_related_hostnames(hostnames_should_have), page: page_number)
    else
      @pagy, dns_should_have = pagy(DnsRecord.all, page: page_number)
    end

    # Fetch the DNS Records related to the hostnames with the hostnames on the shouldnt have list
    if !hostnames_shouldnt_have.nil?
      @pagy, dns_shouldnt_have = pagy(DnsRecord.with_related_hostnames(hostnames_shouldnt_have), page: page_number)
    end

    # Removing the dns related with the shouldnt have hostnames
    if dns_shouldnt_have.nil?
      @dns_records = dns_should_have
    else
      @dns_records = dns_should_have - dns_shouldnt_have
    end

    hostnames_query = 'hostname IS NOT "'+hostnames_should_have.join('" AND hostname IS NOT "' )+'"'

    @dns_records.each do |dns|
      related_hostnames = related_hostnames + dns.hostnames.where(hostnames_query).to_a
    end

    related_hostnames.uniq!

    @json = {
      total_records: @dns_records.size,
      records: @dns_records.map { |dns| _json_dns_record(dns) },
      related_hostnames: related_hostnames.map { |hostname| _json_hostname_record(hostname) }
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
