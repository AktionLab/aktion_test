require 'spec_helper'

describe AktionTest::Matchers::FileSystem::FileExistance::Matcher do
  context "an existing file" do
    let(:file) { __FILE__ }

    it "will be accepted" do
      file.should be_a_file
    end

    it "provides a negative failure message" do
      matcher = described_class.new
      matcher.matches?(file)
      matcher.negative_failure_message.should == <<-MSG.strip_heredoc.strip
        Did not expect #{file} to be a file.
      MSG
    end

    it "provides a failure message with an unknown problem" do
      matcher = described_class.new
      matcher.matches?(file)
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected #{file} to be a file.
        Unknown
      MSG
    end
  end

  context "a non-existant file" do
    let(:file) { File.expand_path(File.join(__FILE__, '..', 'foo')) }

    it "will not be accepted" do
      file.should_not be_a_file
    end

    it "explains that the subject does not exist" do
      matcher = described_class.new
      matcher.matches?(file)
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected #{file} to be a file.
        #{file} does not exist.
      MSG
    end
  end

  context "an existing directory" do
    let(:file) { File.expand_path(File.join(__FILE__, '..')) }

    it "will not be accpeted" do
      file.should_not be_a_file
    end

    it "explains that the subject is a directory" do
      matcher = described_class.new
      matcher.matches?(file)
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected #{file} to be a file.
        #{file} is a directory.
      MSG
    end
  end
end
