require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "user with a valid email should be valid" do
    user = User.new(email: 'user3@demo.org', password_digest: "pass", username: "user3")
    assert user.valid?
  end

  test "user with invalid email should be invalid" do
    user = User.new(email: 'user1', password_digest: "pass", username: "user1")
    assert_not user.valid?
  end


  test "user with taken email should be invalid" do
    user_one = users(:one)
    user = User.new(email: user_one.email, password_digest: "pass2", username: "any_user")
    assert_not user.valid?
  end
end
