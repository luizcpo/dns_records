class DnsRecordsController < ApplicationController
  include Pagy::Backend

  skip_before_action :verify_authenticity_token

  # TODO This action got really big, if I had more time, I would create a
  # service to deal with most of the logic implemented here.

  # TODO Another thing that I would do is to validate both the endpoint's
  # contracts using the json-schema gem maybe.

  # TODO With more time, we could use a cache system as Redis for instance
  # and get the API a little bit more efficient
  def index
    related_hostnames = []
  
    if validate_hostnames_params('should_have')
      hostnames_should_have = params['hostnames']['should_have']
    else
      hostnames_should_have = nil
    end

    if validate_hostnames_params('shouldnt_have')
      hostnames_shouldnt_have = params['hostnames']['shouldnt_have']
    else
      hostnames_shouldnt_have = nil
    end

    page_number = params['page']
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

    # Getting the hostnames related with the dns records we fetched
    if hostnames_should_have.nil?
      @dns_records.each do |dns|
        related_hostnames = related_hostnames + dns.hostnames.to_a
      end
    else
      hostnames_query = 'hostname IS NOT "'+hostnames_should_have.join('" AND hostname IS NOT "' )+'"'

      @dns_records.each do |dns|
        related_hostnames = related_hostnames + dns.hostnames.where(hostnames_query).to_a
      end
    end

    related_hostnames.uniq!

    @json = {
      total_records: @dns_records.size,
      records: @dns_records.map { |dns| _json_dns_record(dns) },
      related_hostnames: related_hostnames.map { |hostname| _json_hostname_record(hostname) }
    }

    render json: @json
  end


  # One thing that I would like to do is to create some kind of validation
  # other then presence validation. Domain and IPV4 validation, maybe?
  def create
    content = JSON.parse(request.raw_post)
    
    attributes = {
      ip_address: content['dns_records']['ip'],
      hostnames_attributes: content['dns_records']['hostnames_attributes']
    }

    @dns_record = DnsRecord.new(attributes)

    if @dns_record.save(attributes)
      render json: { id: @dns_record.id }
    else
      render json: @dns_record.errors.messages
    end
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

  def validate_hostnames_params(params_name)
    return false unless params.has_key? "hostnames"
    params["hostnames"].has_key? params_name
  end
end
