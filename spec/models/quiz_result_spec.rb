require 'spec_helper'

describe QuizResult do
  it { should belong_to(:quiz) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:correct_answers) }
  it { should validate_presence_of(:points) }

  it "knows the name of its user" do
    user = User.make :full_name => 'John Doe'
    result = QuizResult.make :user => user

    result.user_name.should == 'John Doe'
  end
end
