require 'spec_helper'

describe Solution do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:task_id) }
  it { should validate_presence_of(:code) }
  it { Factory(:solution).should validate_uniqueness_of(:user_id).scoped_to(:task_id) }

  it { should belong_to(:user) }
  it { should belong_to(:task) }

  it "can find all the solutions for task" do
    task = Task.make
    solution = Solution.make(:task => task)

    Solution.for_task(task.id).should == [solution]
  end

  it "can find the number of rows in the code" do
    Solution.new(:code => 'print("baba")').rows.should == 1
    Solution.new(:code => "1\n2").rows.should == 2
    Solution.new(:code => "1\n2\n3").rows.should == 3
  end

  describe "submitting" do
    let(:user) { User.make }
    let(:task) { Task.make }

    it "creates a new solution for the given user and task" do
      Solution.submit user, task, 'code'

      Solution.exists?(:user_id => user.id, :task_id => task.id, :code => 'code').should be_true
    end

    it "updates the current solution if it exists" do
      solution = Solution.make :user => user, :task => task, :code => 'old code'

      Solution.submit user, task, 'new code'

      solution.reload
      solution.code.should == 'new code'
    end

    it "returns true on success" do
      Solution.submit(user, task, 'new code').should be_true
    end

    it "returns false on failure" do
      Solution.submit(user, task, nil).should be_false
    end

    it "does not update the solution after the task is closed" do
      task = Factory(:closed_task)
      solution = Factory(:solution, :task => task, :user => user, :code => 'old code')

      Solution.submit user, task, 'new code'

      solution.reload
      solution.code.should == 'old code'
    end
  end

  describe "looking up the code of an existing solution" do
    let(:user) { User.make }
    let(:task) { Task.make }

    it "retuns the code as a string" do
      Solution.make :user => user, :task => task, :code => 'code'
      Solution.code_for(user, task).should == 'code'
    end

    it "returns nil if the no solution submitted by this user" do
      Solution.code_for(user, task).should be_nil
    end
  end

  describe "(calculating points)" do
    [
      [15, 0, 5],
      [14, 1, 5],
      [13, 2, 4],
      [10, 5, 3],
    ].each do |passed, failed, points|
      it "has #{points} points for #{passed} passed and #{failed} failed tests" do
        Solution.new(:passed_tests => passed, :failed_tests => failed).points.should == points
      end
    end

    it "has 0 points if not checked" do
      Solution.new.points.should == 0
    end
  end
end
