require 'test_helper'

module Geocms
  class PagesControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end

  end
end
