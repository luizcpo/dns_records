require 'test_helper'

class HostnamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hostname = hostnames(:one)
  end

  test "should get index" do
    get hostnames_url
    assert_response :success
  end

  test "should get new" do
    get new_hostname_url
    assert_response :success
  end

  test "should create hostname" do
    assert_difference('Hostname.count') do
      post hostnames_url, params: { hostname: { name: @hostname.name } }
    end

    assert_redirected_to hostname_url(Hostname.last)
  end

  test "should show hostname" do
    get hostname_url(@hostname)
    assert_response :success
  end

  test "should get edit" do
    get edit_hostname_url(@hostname)
    assert_response :success
  end

  test "should update hostname" do
    patch hostname_url(@hostname), params: { hostname: { name: @hostname.name } }
    assert_redirected_to hostname_url(@hostname)
  end

  test "should destroy hostname" do
    assert_difference('Hostname.count', -1) do
      delete hostname_url(@hostname)
    end

    assert_redirected_to hostnames_url
  end
end
