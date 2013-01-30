require 'spec_helper'
require 'active_support/core_ext/string'

describe AktionTest::Matchers::FileSystem::DirectoryContains::Matcher do
  let(:test_root) { File.expand_path(File.join(__FILE__, '..', '..', 'tmp')) }

  before(:each) do
    FileUtils.rm_rf(test_root) if Dir.exists?(test_root)
  end

  def build(structure, root=test_root)
    FileUtils.mkdir(root) unless Dir.exists?(root)

    structure.each do |entry|
      case entry
      when String
        FileUtils.touch("#{root}/#{entry}")
      when Hash
        entry.each{|k,v| build(v, "#{root}/#{k}")}
      end
    end
  end

  def matcher(*args)
    @matcher ||= described_class.new(*args)
  end

  context "with a matching tree" do
    it "provides a negative failure message" do
      build(['test_file'])
      matcher = described_class.new(['test_file'])
      matcher.matches?(test_root)
      matcher.negative_failure_message.should == <<-MSG.strip_heredoc
        Did not expect #{test_root} to contain:
          test_file


      MSG
    end
  end

  context "single file in the root" do
    it "will accept if the file exists" do
      build(['test_file'])
      test_root.should have_tree(['test_file'])
    end

    it "will not accept if the file does not exist" do
      test_root.should_not have_tree(['test_file'])
    end

    it "will not accept if the file is in a subdirectory" do
      build([{'a' => ['test_file']}])
      test_root.should_not have_tree(['test_file'])
    end
  end

  context "single file in a specific directory" do
    it "will accept if the file exists in the subdirectory" do
      build([{'a' => ['test_file']}])
      test_root.should have_tree([{'a' => ['test_file']}])
    end

    it "will not accept if the file does not exist" do
      test_root.should_not have_tree([{'a' => ['test_file']}])
    end

    it "will not accept if the file exists in the root" do
      build(['test_file'])
      test_root.should_not have_tree([{'a' => ['test_file']}])
    end

    it "will not accept if the file exists in another directory" do
      build([{'b' => ['test_file']}])
      test_root.should_not have_tree([{'a' => ['test_file']}])
    end
  end

  context "single file in a specific tree" do
    let(:tree) { [{'a' => [{'b' => [{'c' => ['test_file']}]}]}] }
    it "will accept if the file exists in the tree" do
      build(tree)
      test_root.should have_tree(tree)
    end
  end

  context "single file in any subdirectory" do
    let(:tree) { [{'*' => ['test_file']}]}

    it "will accept if the file exists in a subdirectory" do
      build([{'a' => ['test_file']}])
      test_root.should have_tree(tree)
    end

    it "will not accept if the file exists deeper in the tree" do
      build([{'a' => [{'b' => ['test_file']}]}])
      test_root.should_not have_tree(tree)
    end
  end

  context "single file in any tree" do
    let(:tree) { [{'**' => ['test_file']}]}

    it "will accept if the file exists in the tree" do
      build([{'a' => [{'b' => [{'c' => ['test_file']}]}]}])
      test_root.should have_tree(tree)
    end
  end

  context "single file with mixed specific and any directory" do
    let(:tree) { [{'a' => [{'*' => [{'c' => ['test_file']}]}]}]}

    it "will accept if the file exists in search path" do
      build([{'a' => [{'b' => [{'c' => ['test_file']}]}]}])
      test_root.should have_tree(tree)
    end

    it "will not accept if the file exists outside the search path" do
      build([{
        'a' => [{
          'c' => ['test_file'],
          'b' => [{
            'd' => [{
              'c' => ['test_file']
              }]
            }]
          }]
        }])
      test_root.should_not have_tree(tree)
    end
  end

  context "single file with mixed specific directories and any tree" do
    let(:tree) { [{'a' => [{'**' => [{'d' => ['test_file']}]}]}]}

    it "will accept if the file exists in the search path" do
      build([{'a' => [{'b' => [{'c' => [{'d' => ['test_file']}]}]}]}])
      test_root.should have_tree(tree)
    end

    it "will not accept if the file is outside the search path" do
      build([{'a' => [{'b' => [{'c' => ['test_file']}]}]}])
      test_root.should_not have_tree(tree)
    end
  end

  context "multiple files in the root directory" do
    let(:tree) { %w(test_file_a test_file_b) }

    it "will accept if all of the files exist" do
      build(%w(test_file_a test_file_b))
      test_root.should have_tree(tree)
    end

    it "will not accept if not all of the files exist" do
      build(['test_file_a'])
      test_root.should_not have_tree(tree)
    end
  end

  context "multiple files a subdirectory" do
    let(:tree) { [{'a' => %w(test_file_a test_file_b)}]}

    it "will accept if all of the files exist" do
      build(tree)
      test_root.should have_tree(tree)
    end

    it "will not accept if not all of the files exist" do
      build([{'a' => %w(test_file_a)}])
      test_root.should_not have_tree(tree)
    end
  end

  context "multiple files in multiple subdirectories" do
    let(:tree) { [{'a' => %w(test_file_a test_file_b), 'b' => %w(test_file_a test_file_b)}]}

    it "will accept if all of the files exist" do
      build(tree)
      test_root.should have_tree(tree)
    end

    it "will not accept if not all of the files exist" do
      build([{'a' => %w(test_file_a test_file_b), 'b' => %w(test_file_b)}])
      test_root.should_not have_tree(tree)
    end
  end

  context "when files do not exist" do
    it "lists the missing files" do
      #build([{'a' => ['test_file_a', {'b' => [{'c' => ['test_file_b', 'test_file_c']}]}]}])
      build([{'a' => ['test_file_a']}])
      matcher(['test_file', {'a' => ['test_file_a', {'b' => [{'c' => ['test_file_b', 'test_file_c']}]}]}]).matches?(test_root)
      matcher.failure_message.should == <<-FAIL.strip_heredoc
        Expected #{test_root} to contain:
          test_file
          a/
            test_file_a
            b/
              c/
                test_file_b
                test_file_c

        test_file was not found
        a/b/c/test_file_b was not found
        a/b/c/test_file_c was not found
      FAIL
    end
  end

  context "when the subject does not exist" do
    let(:nx_root) { File.join(test_root, 'a') }

    it "will not be accepeted" do
      nx_root.should_not have_file('some_file')
    end

    it "specifies the problem as the subject not existing" do
      matcher(['some_file']).matches?(nx_root)
      matcher.failure_message.should == <<-FAIL.strip_heredoc
        Expected #{nx_root} to contain:
          some_file

        #{nx_root} does not exist.
      FAIL
    end
  end

  context "when the subject is not a directory" do
    before(:each) { build(['test_file']) }

    it "will not be accepted" do
      File.join(test_root, 'test_file').should_not have_file('some_file')
    end

    it "specifies the problem as the subject not being a directory" do
      bad_root = File.join(test_root, 'test_file')
      matcher(['some_file']).matches?(bad_root)
      matcher.failure_message.should == <<-FAIL.strip_heredoc
        Expected #{bad_root} to contain:
          some_file

        #{bad_root} is not a directory.
      FAIL
    end
  end
end
