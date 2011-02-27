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

  context "User protected attributes" do

    should "not be saved by mass assignment" do
      # PS: password is a virtual attribute, has to be added manually
      orig_user = @user.attributes.merge("password" => @user.password)
      @user.save
      @user.update_attributes!(
        :email => "hackety@hack.com",
        :password => "hacketyhack",
        :nickname => "hacketyhack",
        :admin => true
      )      
      @user = User.find(@user.to_param)

      assert ! User.authenticate(@user.email, "hacketyhack")
      assert User.authenticate(orig_user["email"], orig_user["password"])
      assert_equal orig_user["nickname"], @user.nickname
      assert ! @user.admin?
    end  

    should "not allow to override password params" do
      orig_user = @user.attributes.merge("password" => @user.password)
      @user.save

      # just to generate another password_hash and password_salt
      @bogus_user = Factory.create(:user,
        :email => "hackety@hack.com",
        :password => "hacketyhack",
        :nickname => "hacketyhack"
      )
      
      @user = User.find(@user.to_param)
      @user.update_attributes!(
        :password_hash => @bogus_user.password_hash,
        :password_salt => @bogus_user.password_salt,
      )

      assert ! User.authenticate(@user.email, "hacketyhack")
      assert User.authenticate(orig_user["email"], orig_user["password"])
    end  


  end

end
