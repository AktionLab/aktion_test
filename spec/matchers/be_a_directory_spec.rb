require 'spec_helper'

describe AktionTest::Matchers::FileSystem::DirectoryExistanceMatcher do
  context "an existing directory" do
    let(:dir) { File.expand_path(File.join(__FILE__, '..')) }

    it "will be accepeted" do
      dir.should be_a_directory
    end

    it "provides a negative failure message" do
      matcher = described_class.new
      matcher.matches?(dir)
      matcher.negative_failure_message.should == <<-MSG.strip_heredoc.strip
        Did not expect #{dir} to be a directory.
      MSG
    end

    it "provides a failure message with an unknown problem" do
      matcher = described_class.new
      matcher.matches?(dir)
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected #{dir} to be a directory.
        Unknown
      MSG
    end
  end

  context "a non-existant directory" do
    let(:dir) { File.expand_path(File.join(__FILE__, '..', 'foo')) }

    it "will not be accepted" do
      dir.should_not be_a_directory
    end

    it "explains that the subject does not exist" do
      matcher = described_class.new
      matcher.matches?(dir)
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected #{dir} to be a directory.
        #{dir} does not exist.
      MSG
    end
  end

  context "a file" do
    let(:dir) { __FILE__ }

    it "will not be accepted" do
      dir.should_not be_a_directory
    end

    it "explains that the subject is a file" do
      matcher = described_class.new
      matcher.matches?(dir)
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected #{dir} to be a directory.
        #{dir} is not a directory.
      MSG
    end
  end
end
