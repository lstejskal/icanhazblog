require 'test_helper'

# this is for testing Date class extensions and monkey patches

class DateTest < ActiveSupport::TestCase
 
  context "Date.to_s" do

    setup do
      @date = Date.parse("05.02.2011")
    end

    should "not return string in default format of Date class" do
      assert_not_equal @date.to_s, "2011-02-05"
    end

    should "return standardized string from monkey patch" do
      assert_equal @date.to_s, "05.02.2011"
    end

  end
  
end

