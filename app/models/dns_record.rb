class DnsRecord < ApplicationRecord
    has_and_belongs_to_many :hostnames, :autosave => true

    accepts_nested_attributes_for :hostnames

    validates :ip_address, presence: true, uniqueness: true
    validates_associated :hostnames

    scope :with_related_hostnames, ->(hostnames_list) { 
      joins(:hostnames)
     .where(:hostnames => {:hostname => hostnames_list})
     .group("dns_records.id")
     .having(['COUNT(*) = ?', hostnames_list.length]) 
    }

    def autosave_associated_records_for_hostnames
        existing_hostnames = []
        new_hostnames = []
      
        hostnames.each do |hostname|
          if existing_hostname = Hostname.find_by_hostname(hostname.hostname)
            existing_hostnames << existing_hostname
          else
            new_hostnames << hostname
          end
        end
      
        self.hostnames << new_hostnames + existing_hostnames
    end
end
