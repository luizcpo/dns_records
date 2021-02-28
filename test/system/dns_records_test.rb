require "application_system_test_case"

class DnsRecordsTest < ApplicationSystemTestCase
  setup do
    @dns_record = dns_records(:one)
  end

  test "visiting the index" do
    visit dns_records_url
    assert_selector "h1", text: "Dns Records"
  end

  test "creating a Dns record" do
    visit dns_records_url
    click_on "New Dns Record"

    fill_in "Ip address", with: @dns_record.ip_address
    click_on "Create Dns record"

    assert_text "Dns record was successfully created"
    click_on "Back"
  end

  test "updating a Dns record" do
    visit dns_records_url
    click_on "Edit", match: :first

    fill_in "Ip address", with: @dns_record.ip_address
    click_on "Update Dns record"

    assert_text "Dns record was successfully updated"
    click_on "Back"
  end

  test "destroying a Dns record" do
    visit dns_records_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dns record was successfully destroyed"
  end
end
