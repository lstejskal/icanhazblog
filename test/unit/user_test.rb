require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = Factory.build(:user)
  end
  
  teardown do
    User.all.each { |u| u.destroy }
  end

  context "When creating User, it" do

    should "not save without email" do
      @user.email = nil
      assert ! @user.save
    end

    should "not save without password" do
      @user.password = nil
      assert ! @user.save
    end

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
  
    should "save only unique nicknames" do
      @user.save
      another_user = Factory.build(:user)
      another_user.nickname = @user.nickname
      assert ! another_user.save    
    end
  
    should "save admin attribute as false by default" do
      user = Factory.create(:user, :admin => nil)
      assert ! user.admin?
    end
    
    should "save with valid attributes" do
      assert @user.save
    end
    
  end

  context "User.find_by_email" do

    should "find user with existing email" do
      @user.save
      assert_not_nil User.find_by_email(@user.email)
    end
  
    should "not find user with non-existent email" do
      assert_nil User.find_by_email("non-existent email")
    end
  end
  
  context "User.authenticate " do
    setup do
      @user = Factory.create(:user)
    end
    
    teardown do
      @user.destroy
    end
  
    should "return nil on invalid authentication data" do
      assert_nil User.authenticate(@user.email, @user.password.reverse)    
    end
  
    should "return User instance valid authentication data" do
      assert_equal User, User.authenticate(@user.email, @user.password).class
    end  
  end

end
