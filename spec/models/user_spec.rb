require 'spec_helper'

describe User do
  #  pending "add some examples to (or delete) #{__FILE__}"
  before { @user = User.new(email:'isit@isit.su', name: 'dmitry') }
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  
  it "should respond to 'name'" do
    expect(@user).to respond_to(:name)
  end
  # or use compact record
  it { should respond_to(:name) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @user.name = " "}
    it { should_not be_valid }
  end
  
  describe "when e-mail is not present" do 
    before { @user.email = "" }
    it { should_not be_valid }
  end
  
  describe "when name length is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

end
