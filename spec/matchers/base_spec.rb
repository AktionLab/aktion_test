require 'spec_helper'

describe AktionTest::Matchers::Base do
  before :each do
    define_class('Matcher', described_class) do
      def expectation;             "an expectation";               end
      def problems_for_should;     "\na problem\nanother problem"; end
      def problems_for_should_not; "\na problem\nanother problem"; end
    end

    define_class 'EmptyMatcher', described_class

    @matcher = ::Matcher.new
  end

  it 'provides a warning that the expectation has not been set' do
    matcher = EmptyMatcher.new
    matcher.stub(:perform_match! => false)
    matcher.matches? nil
    matcher.failure_message.should =~ /Override expectation to provide expectation details/
  end

  it 'raises an error if perform_match! is not overriden' do
    matcher = EmptyMatcher.new
    expect { matcher.matches? nil }.to raise_error(/Override perform_match!/)
  end
    
  describe '#failure_message' do
    it "outputs an expectation with associated problems when the matcher is unsuccessful" do
      @matcher.stub(:perform_match! => false)
      @matcher.matches?(nil)
      @matcher.failure_message.should == <<-MSG.strip_heredoc
        Expected an expectation

        a problem
        another problem
      MSG
    end

    it "raises an error if called before running the matcher" do
      expect { @matcher.failure_message }.to raise_error(RuntimeError, /failure message before/)
    end

    it "raises an error if called when the matcher was successful" do
      @matcher.stub(:perform_match! => true)
      @matcher.matches? nil
      expect { @matcher.failure_message }.to raise_error(RuntimeError, /failure message while/)
    end

    it 'provides a warning the failure message has not been set' do
      matcher = EmptyMatcher.new
      matcher.stub(:perform_match! => false)
      matcher.matches? nil
      matcher.failure_message.should =~ /Override problem_for_should /
    end
  end

  describe '#negative_failure_message' do
    before { @matcher.stub(:perform_match! => true) }
    it 'outputs a negative expectation with associated problems when the matcher is successful' do
      @matcher.matches?(nil)
      @matcher.negative_failure_message.should == <<-MSG.strip_heredoc
        Did not expect an expectation

        a problem
        another problem
      MSG
    end

    it "raises an error if called before running the matcher" do
      expect { @matcher.negative_failure_message }.to raise_error(RuntimeError, /negative failure message before/)
    end

    it "raises an error if called when the matcher was unsuccessful" do
      @matcher.stub(:perform_match! => false)
      @matcher.matches? nil
      expect { @matcher.negative_failure_message }.to raise_error(RuntimeError, /negative failure message while/)
    end

    it 'provides a warning the failure message has not been set' do
      matcher = EmptyMatcher.new
      matcher.stub(:perform_match! => true)
      matcher.matches? nil
      matcher.negative_failure_message.should =~ /Override problem_for_should_not/
    end
  end
end
