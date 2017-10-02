require 'test_helper'

class IndustriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @industry = Industry.first
  end

  test "should get index" do
    get industries_url
    assert_response :success
  end

  test "should get new" do
    get new_industry_url
    assert_response :success
  end

  test "should create industry" do
    assert_difference('Industry.count') do
      post industries_url, params: { industry: { level: @industry.level, name: @industry.name, parrent_id: @industry.parrent_id } }
    end

    assert_redirected_to industry_url(Industry.last)
  end

  test "should show industry" do
    get industry_url(@industry)
    assert_response :success
  end

  test "should get edit" do
    get edit_industry_url(@industry)
    assert_response :success
  end

  test "should update industry" do
    patch industry_url(@industry), params: { industry: { level: @industry.level, name: @industry.name, parrent_id: @industry.parrent_id } }
    assert_redirected_to industry_url(@industry)
  end

  test "should destroy industry" do
    assert_difference('Industry.count', -1) do
      delete industry_url(@industry)
    end

    assert_redirected_to industries_url
  end
end
