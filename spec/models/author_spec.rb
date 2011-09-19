require 'spec_helper'

describe Author do
  before(:each) do
    @valid_author_attributes = {
      :login => 'john_silver',
      :fio => 'John Silver Heaney',
      :password => '123456'
    }
    @author = Author.create(@valid_author_attributes)
  end

  it "should create author" do
    @author.should_not be_a_new_record
  end

  it "should change fio" do
    @author.change_fio({:fio => "Helena Gerzikova"})
    @author.fio.should == "Helena Gerzikova"
  end

  it "should not change fio" do
    @author.change_fio({:fio => ""})
    @author.errors.on('fio').should == I18n.t(:author_without_fio)
    @author.reload
    @author.fio.should == "John Silver Heaney"
  end

  it "should change password" do
    @author.change_password({:password => "111111", :password_confirmation => '111111'}).should be_true
    @author.errors.should be_empty
  end

  it "should not change not confirmed password" do
    @author.change_password({:password => "111111", :password_confirmation => '222222'}).should_not be_true
    @author.errors.on('password').should == I18n.t(:password_not_confirmed)
  end

  it "should not change short password" do
    @author.change_password({:password => "1", :password_confirmation => '1'}).should_not be_true
    @author.errors.on('password').should == I18n.t(:password_too_short)
  end

  it "should not change long password" do
    @author.change_password({:password => "12345678901234567890123456789", :password_confirmation => '12345678901234567890123456789'}).should_not be_true
    @author.errors.on('password').should == I18n.t(:password_too_long)
  end
end
