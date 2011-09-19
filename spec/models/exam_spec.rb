require 'spec_helper'

describe Exam do

  it "should be valid" do
    exam = Exam.new
    exam.should_not be_valid
  end
end
