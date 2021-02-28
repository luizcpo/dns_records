class CreateTableDnsRecordsHostnames < ActiveRecord::Migration[5.2]
  def change
    create_table :dns_records_hostnames do |t|
      t.belongs_to :dns_record
      t.belongs_to :hostname
    end
  end
end
