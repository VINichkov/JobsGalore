require 'test_helper'
require 'rails/performance_test_help'

class HomepageTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  test "homepage" do
    get '/'
  end
  test "about us" do
    get '/about'
  end
  test "search_job" do
    get 'search?utf8=✓&main_search[type]=2&main_search[value]='
  end
  test "search_resume" do
    get '/search?utf8=✓&main_search[type]=3&main_search[value]='
  end
  test "search_company" do
    get '/search?utf8=✓&main_search[type]=1&main_search[value]='
  end
end
