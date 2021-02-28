require "application_system_test_case"

class HostnamesTest < ApplicationSystemTestCase
  setup do
    @hostname = hostnames(:one)
  end

  test "visiting the index" do
    visit hostnames_url
    assert_selector "h1", text: "Hostnames"
  end

  test "creating a Hostname" do
    visit hostnames_url
    click_on "New Hostname"

    fill_in "Name", with: @hostname.name
    click_on "Create Hostname"

    assert_text "Hostname was successfully created"
    click_on "Back"
  end

  test "updating a Hostname" do
    visit hostnames_url
    click_on "Edit", match: :first

    fill_in "Name", with: @hostname.name
    click_on "Update Hostname"

    assert_text "Hostname was successfully updated"
    click_on "Back"
  end

  test "destroying a Hostname" do
    visit hostnames_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hostname was successfully destroyed"
  end
end
