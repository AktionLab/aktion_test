require 'spec_helper'
require 'active_support/core_ext/string'

describe AktionTest::Matchers::FileSystem::DirectoryContentMatcher do
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

  context 'single file' do
    context "within the directory" do
      before(:each) { build(['test_file']) }

      it "will be accepted if the file exists" do
        test_root.should have_file('test_file')
      end

      it "will not be accepted if the file does not exist" do
        test_root.should_not have_file('nxfile')
      end

      it "specifies the problem as the file not being found" do
        matcher(['nxfile']).matches?(test_root)
        matcher.failure_message.should == <<-FAIL.strip_heredoc.strip
          Expected #{test_root} to contain:
            nxfile

          nxfile was not found
        FAIL
      end
    end

    context "within a subdirectory" do
      before(:each) { build([{'a' => ['test_file']}]) }

      it "will be accepted if the file exists" do
        test_root.should have_file('test_file')
      end

      it "will not be accepted if the file does not exist" do
        test_root.should_not have_file('nxfile')
      end

      it "specifies the problem as the file not being found" do
        matcher(['nxfile']).matches?(test_root)
        matcher.failure_message.should == <<-FAIL.strip_heredoc.strip
          Expected #{test_root} to contain:
            nxfile

          nxfile was not found
        FAIL
      end
    end
  end

  context 'multiple files' do
    context 'within the directory' do
      let(:files) { %w(a b c).map{|f| "test_file_#{f}"} }
      before(:each) { build(files) }

      it 'will be accepted if all of the files exist' do
        test_root.should have_files(files)
      end

      it 'will not be accepeted if some of the files are missing' do
        test_root.should_not have_files(files << 'nxfile')
      end

      it 'specifies the problem as the files that are missing' do
        matcher(files + %w(nxfile_a nxfile_b)).matches?(test_root)
        matcher.failure_message.should == <<-FAIL.strip_heredoc.strip
          Expected #{test_root} to contain:
            test_file_a
            test_file_b
            test_file_c
            nxfile_a
            nxfile_b

          nxfile_a was not found
          nxfile_b was not found
        FAIL
      end
    end

    context 'within subdirectories' do
      let(:files) { %w(a b c).map{|f| "test_file_#{f}"} }
      before(:each) do
        build([
          'a' => ['test_file_a'],
          'b' => ['test_file_b', 'test_file_c']
        ])
      end

      it 'will be accepted if all of the files exist' do
        test_root.should have_files(files)
      end

      it 'will not be accepeted if any of the files are missing' do
        test_root.should_not have_files(files << 'nxfile')
      end

      it 'specifies the problem as the files that are missing' do
        matcher(files + %w(nxfile_a nxfile_b)).matches?(test_root)
        matcher.failure_message.should == <<-FAIL.strip_heredoc.strip
          Expected #{test_root} to contain:
            test_file_a
            test_file_b
            test_file_c
            nxfile_a
            nxfile_b

          nxfile_a was not found
          nxfile_b was not found
        FAIL
      end
    end
  end

  context "when the subject does not exist" do
    let(:nx_root) { File.join(test_root, 'a') }

    it "will not be accepeted" do
      nx_root.should_not have_file('some_file')
    end

    it "specifies the problem as the subject not existing" do
      matcher(['some_file']).matches?(nx_root)
      matcher.failure_message.should == <<-FAIL.strip_heredoc.strip
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
      matcher.failure_message.should == <<-FAIL.strip_heredoc.strip
        Expected #{bad_root} to contain:
          some_file

        #{bad_root} is not a directory.
      FAIL
    end
  end
end
