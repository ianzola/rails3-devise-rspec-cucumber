require 'spec_helper'

describe User do

  let(:user){ FactoryGirl.build(:user) }

  it "should create a new instance given a valid attribute" do
    lambda { user.save! }.should_not raise_error
  end

  context "--- Email" do  
    it { should validate_presence_of(:email) }

    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each { |address| should allow_value(address).for(:email) }
    end

    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each { |address| should_not allow_value(address).for(:email) }
    end

    it "should reject duplicate email addresses" do
      should validate_uniqueness_of(:email) 
    end

    it "should reject email addresses identical up to case" do
      FactoryGirl.create(:user, :email => user.email.upcase)    
      should_not allow_value(user.email).for(:email)
    end
  end
  
  context "--- Passwords" do  

    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }

    describe "password validations" do

      it { should validate_presence_of(:password) }

      it "should require a matching password confirmation" do
        FactoryGirl.build(:user, :password_confirmation => "invalid").should_not be_valid
      end

      it "should reject short passwords" do
        should_not allow_value("a" * 5).for(:password)
      end    
    end

    describe "password encryption" do
      let(:saved_user){ FactoryGirl.create(:user)}

      it { should respond_to(:encrypted_password) }
      it "should set the encrypted password attribute" do
        saved_user.encrypted_password.should_not be_blank 
      end
    end
  end

end