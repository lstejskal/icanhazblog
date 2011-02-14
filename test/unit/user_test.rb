require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = Factory.build(:user)
  end

  teardown do
    User.all.each { |u| u.destroy }
  end

  test "should not save without email" do
    @user.email = nil
    assert ! @user.save
  end

  test "should not save without password" do
    @user.password = nil
    assert ! @user.save
  end

  test "should not save without nickname" do
    @user.nickname = nil
    assert ! @user.save
  end
  
  test "should save only unique emails" do
    @user.save
    another_user = Factory.build(:user)
    another_user.email = @user.email
    assert ! another_user.save
  end

  test "should save only unique nicknames" do
    @user.save
    another_user = Factory.build(:user)
    another_user.nickname = @user.nickname
    assert ! another_user.save    
  end

  test "should save admin attribute as false by default" do
    user = Factory.create(:user, :admin => nil)
    assert ! user.admin?
  end
  
  test "should save with valid attributes" do
    assert @user.save
  end

  test "should find user with existing email" do
    @user.save
    assert_not_nil User.find_by_email(@user.email)
  end

  test "should not find user with non-existent email" do
    assert_nil User.find_by_email("non-existent email")
  end
  
  test "should be authenticated with valid password" do
    @user.save
    assert_not_nil User.authenticate(@user.email, @user.password)
  end

  test "should not be authenticated with invalid password" do
    @user.save
    assert_nil User.authenticate(@user.email, @user.password.reverse)    
  end

end
