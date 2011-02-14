require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
 
  setup do
    @user = Factory.build(:user)
  end
  
  teardown do
    User.all.each { |u| u.destroy }
  end

  context "When creating User, it" do

    should "not save without nickname" do
      @user.nickname = nil
      assert ! @user.save
    end
    
    should "save only unique emails" do
      @user.save
      another_user = Factory.build(:user)
      another_user.email = @user.email
      assert ! another_user.save
    end
    
  end

end
