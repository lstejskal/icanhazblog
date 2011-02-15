require 'test_helper'

class TagTest < ActiveSupport::TestCase

  setup do
    @tag = Factory.build(:tag)
  end
    
  teardown do
    @tag.destroy
  end

  context "When creating Tag, it" do

    should "not save without tag name" do
      @tag.name = nil
      assert ! @tag.save
    end

    should "not save with tag name over max. length" do
      @tag.name = random_string(51)
      assert ! @tag.save
    end

    should "save only unique tag names" do
      @tag.save
      another_tag = Factory.build(:tag)
      another_tag.name = @tag.name
      assert ! another_tag.save    
    end
  
    should "save with valid data" do
      assert @tag.save
    end
  
  end

end
