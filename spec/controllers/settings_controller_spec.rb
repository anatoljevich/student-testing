require 'spec_helper'

describe SettingsController do
  integrate_views
  fixtures :authors
  
  before(:each) do
    controller.stub!(:current_author).and_return authors(:testauthor)
  end

  it "should set an author" do
    get :index
    assigns[:author].should == controller.send(:current_author)
  end

  it "should rename an author" do
    post :rename, :author => {:fio => 'Prince Of Percia'}
    flash[:notice].should == I18n.t(:author_renamed)
    response.should render_template('index')
  end

  it "should not rename an author" do
    post :rename, :author => {:fio => ''}
    flash[:notice].should be_nil
    response.should render_template('index')

    post :rename
    flash[:notice].should be_nil
    response.should render_template('index')
  end

  it "should change author password" do
    post :change_password, :author => {:password => '111111', :password_confirmation => '111111'}
    controller.send(:current_author).password.should == '111111'
    flash[:notice].should == I18n.t(:author_password_changed)
    response.should render_template('index')
  end

  it "should not change author password" do
    post :change_password, :author => {:password => '111111', :password_confirmation => ''}
    controller.send(:current_author).password.should be_nil
    flash[:notice].should be_nil
    response.should render_template('index')
  end
end
