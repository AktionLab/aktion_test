require 'spec_helper'

describe AktionTest::Matchers::FileSystem::FileContains::Matcher do
  def create_file(file='tmp/test_file', &block)
    FileUtils.mkdir('tmp') unless Dir.exists? 'tmp'
    File.open(file, 'w') {|f| f << yield }
  end

  after(:each) do
    Dir['tmp/*'].each {|f| FileUtils.rm f}
  end

  context 'a file that does not exist' do
    it "will not be accepted" do
      'tmp/test_file'.should_not match_lines(['anything'])
    end

    it 'explains that the file was not found' do
      matcher = described_class.new(['anything'])
      matcher.matches?('tmp/test_file')
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected tmp/test_file to have contents:
        ---
        anything
        ---
        tmp/test_file does not exist.
      MSG
    end
  end

  context 'a file that is actually a directory' do
    it 'will not be accepted' do
      File.dirname(__FILE__).should_not match_lines(['anything'])
    end

    it 'explains that the file is a directory' do
      matcher = described_class.new(['anything'])
      matcher.matches?(File.dirname(__FILE__))
      matcher.failure_message.should == <<-MSG.strip_heredoc.strip
        Expected #{File.dirname(__FILE__)} to have contents:
        ---
        anything
        ---
        #{File.dirname(__FILE__)} is a directory.
      MSG
    end
  end

  context 'a file that exists' do
    before(:each) do
      create_file do
        <<-FILE.strip_heredoc
          lorem
          ipsum
          dolar
          amet
        FILE
      end
    end

    context 'with all matching content' do
      it 'will be accpeted' do
        'tmp/test_file'.should match_lines(['lorem'])
      end

      it 'will be accepted with a regex' do
        'tmp/test_file'.should match_lines([/^ips/])
      end

      it 'will be accepted with a multiline match' do
        match_content = <<-MATCH.strip_heredoc.strip
          lorem
          ipsum
          dolar
          amet
        MATCH
        'tmp/test_file'.should match_lines([match_content])
      end
    end

    context 'with no matching content after a specified point' do
      it 'will not be accepted' do
        'tmp/test_file'.should_not match_lines(['lorem'], :after => 'ipsum')
        'tmp/test_file'.should_not match_lines(['lorem']).after('ipsum')
        'tmp/test_file'.should_not match_lines(['lorem'], :after => /sum$/)
        'tmp/test_file'.should_not match_lines(['lorem']).after(/sum$/)
      end
    end

    context 'with matching content after a specified point' do
      it 'will be accepted' do
        'tmp/test_file'.should match_lines(['dolar','amet']).after('ipsum')
      end

      context 'when the matching content includes the point' do
        it 'will not be accepted' do
          'tmp/test_file'.should_not match_lines(['dolar','amet']).after('dolar')
        end
      end
    end

    context 'with no matching content before a specified point' do
      it 'will not be accepted' do
        'tmp/test_file'.should_not match_lines(['amet'], :before => 'dolar')
        'tmp/test_file'.should_not match_lines(['amet'], :before => /^dol/)
        'tmp/test_file'.should_not match_lines(['amet']).before('dolar')
        'tmp/test_file'.should_not match_lines(['amet']).before(/^dol/)
      end
    end

    context 'with matching content before a specified point' do
      it 'will be accepted' do
        'tmp/test_file'.should match_lines(['lorem','ipsum']).before('dolar')
      end

      context 'when the matching content includes the point' do
        it 'will not be accepted' do
          'tmp/test_file'.should_not match_lines(['lorem','ipsum']).before('ipsum')
        end
      end
    end

    context 'with matching content before and after specified points' do
      it 'will be accpeted' do
        'tmp/test_file'.should match_lines(['dolar']).before('amet').after('ipsum')
      end
    end

    context 'without matching content in order' do
      it 'will not be accepted' do
        'tmp/test_file'.should_not match_lines(['lorem','dolar'], :sequentially => true)
        'tmp/test_file'.should_not match_lines(['lorem','dolar']).sequentially
      end
    end

    context 'with matching content in order' do
      it 'will be accepted' do
        'tmp/test_file'.should match_lines(%w(ipsum dolar amet)).sequentially
      end
    end

    context 'with no matching content in order after a specified point' do
      it 'will not be accepted' do
        'tmp/test_file'.should_not match_lines(%w(lorem ipsum dolar)).sequentially.after('ipsum')
      end
    end

    context 'with no matching content in order before a specified point' do
      it 'will not be accepted' do
        'tmp/test_file'.should_not match_lines(%w(ipsum dolar amet)).sequentially.before('dolar')
      end
    end

    context 'without any matching content' do
      it 'will not be accepted' do
        'tmp/test_file'.should_not match_lines(['nothing'])
      end
    end

    context 'with partial matching content' do
      context 'when matching all lines (default)' do
        it 'will not be accepted' do
          'tmp/test_file'.should_not match_lines(['some','thing'])
        end
      end

      context 'when matching any lines' do
        it 'will be accepted' do
          'tmp/test_file'.should match_lines(['lorem','dolar'], allow_any: true)
          'tmp/test_file'.should match_lines(['lorem','dolor']).allow_any
        end
      end
    end
  end
end

