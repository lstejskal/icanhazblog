require 'test_helper'

class TagTest < ActiveSupport::TestCase

  setup do
    @tag = Factory.build(:tag)
  end
    
  teardown do
    @tag.destroy
  end

  context "When creating Tag, it" do

    should "not save without name" do
      @tag.name = nil
      assert ! @tag.save
    end

    should "not save with name over max. length" do
      @tag.name = random_string(51)
      assert ! @tag.save
    end

    should "save with valid data" do
      assert @tag.save
    end
  
  end

end
