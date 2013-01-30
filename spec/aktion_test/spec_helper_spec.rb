require 'spec_helper'

describe AktionTest::SpecHelper do
  subject { described_class.instance }
  before { subject.reset }

  its(:modules) { should be_a Array }
  its(:options) { should be_a Hash }
  its(:scope)   { should be_a Array }
  its(:scope)   { should == %w(AktionTest Module) }

  describe '#within' do
    it 'allows a scope to be added' do
      described_class.within :Test do
        subject.scope.should == %w(AktionTest Module Test)
      end
      subject.scope.should == %w(AktionTest Module)
    end
  end

  describe '#load' do
    before do
      subject.scope.pop(2)
      subject.scope << 'Baz'
    end

    it 'initializes the module' do
      Baz.autoload?(:Bar).should == 'support/test_module'
      described_class.load :Bar
      Baz.autoload?(:Bar).should be_nil
    end

    it 'adds the module to a set of loaded modules' do
      described_class.load :Bar
      subject.modules.should == [Baz::Bar]
    end

    it 'saves options for the module loaded' do
      described_class.load :Bar, :test => :option
      subject.options.should have_key(:Bar)
      subject.options[:Bar].should == {:test => :option}
    end
  end
end
