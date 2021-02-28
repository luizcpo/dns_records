# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
DnsRecord.create(ip_address: '1.1.1.1', hostnames_attributes: [
    { hostname: 'lorem.com' },
    { hostname: 'ipsum.com' },
    { hostname: 'dolor.com' },
    { hostname: 'amet.com' }
])
DnsRecord.create(ip_address: '2.2.2.2', hostnames_attributes: [
    { hostname: 'ipsum.com' }
])
DnsRecord.create(ip_address: '3.3.3.3', hostnames_attributes: [
    { hostname: 'ipsum.com' },
    { hostname: 'dolor.com' },
    { hostname: 'amet.com' }
])
DnsRecord.create(ip_address: '4.4.4.4', hostnames_attributes: [
    { hostname:'ipsum.com' },
    { hostname:'dolor.com' },
    { hostname:'sit.com' },
    { hostname:'amet.com' }
])
DnsRecord.create(ip_address: '5.5.5.5', hostnames_attributes: [
    { hostname: 'dolor.com' },
    { hostname: 'sit.com' }
])