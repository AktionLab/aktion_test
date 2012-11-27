require 'spec_helper'

describe AktionTest::Matchers::Base do
  it "requires the extending class to implement #expectation" do
    matcher = define_class('Matcher', described_class)
    expect { matcher.new.failure_message }.to raise_error(NameError, /`expectation'/)
    expect { matcher.new.negative_failure_message }.to raise_error(NameError, /`expectation'/)
  end

  it "requires the extending class to implement #problem" do
    matcher = define_class('Matcher', described_class) do
    protected
      def expectation
        ''
      end
    end

    expect { matcher.new.failure_message }.to raise_error(NameError, /`problem'/)
  end

  it "provides a failure message based on #expectation and #problem" do
    matcher = define_class('Matcher', described_class) do
    protected
      def expectation
        'an expectation'
      end

      def problem
        'A Problem'
      end
    end

    matcher.new.failure_message.should == <<-MSG.strip_heredoc.strip
      Expected an expectation
      A Problem
    MSG
  end

  it "provides a negative failure message based on #expectation" do
    matcher = define_class('Matcher', described_class) do
    protected
      def expectation
        'an expectation'
      end
    end

    matcher.new.negative_failure_message.should == <<-MSG.strip_heredoc.strip
      Did not expect an expectation
    MSG
  end
end
