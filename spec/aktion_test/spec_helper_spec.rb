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
    it 'initializes the module, adds it to a set of loaded modules, and saves any options' do
      subject.scope.pop(2)
      subject.scope << 'Baz'

      Baz.autoload?(:Bar).should_not be_nil

      described_class.load :Bar, :test => :option

      subject.modules.should == [Baz::Bar]
      Baz.autoload?(:Bar).should be_nil
      subject.options.should have_key(:Bar)
      subject.options[:Bar].should == {:test => :option}
    end
  end
end
