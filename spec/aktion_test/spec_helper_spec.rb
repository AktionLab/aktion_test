require 'spec_helper'

describe AktionTest::SpecHelper do
  describe '::build' do
    it 'instance evals the given block within the context of a spec helper' do
      be_kind_of_spec_helper = be_kind_of described_class
      described_class.build { self.should be_kind_of_spec_helper }
    end

    it 'returns the spec helper instance used in the instance eval' do
      sh1 = nil
      sh2 = described_class.build {sh1 = self}
      sh1.should == sh2
    end
  end

  describe '::new' do
    its(:modules) { should be_a Array }
    its(:modules) { should be_empty }
    its(:scope)   { should == %w(AktionTest Module) }
  end

  describe '#use' do
    before do
      define_class 'TestMod', AktionTest::Module::Base
    end

    it 'creates a new module of the given class' do
      subject.use TestMod
      subject.modules.first.should be_kind_of TestMod
    end

    it 'creates a new module of the given string without a scope' do
      subject.use '::TestMod'
      subject.modules.first.should be_kind_of TestMod
    end

    it 'creates a new module of the given symbol with a scope' do
      module TestModule; end
      define_class 'TestMod', AktionTest::Module::Base, TestModule
      subject.scope = ['TestModule']
      subject.use :TestMod
      subject.modules.first.should be_kind_of TestModule::TestMod
    end

    it 'forwards any options to the new module' do
      TestMod.should_receive(:new).with(kind_of(AktionTest::SpecHelper), :with => :options)
      subject.use TestMod, :with => :options
    end

    it 'raises an ArgumentError if the class is not a base module' do
      define_class 'NonMod'
      expect { subject.use NonMod }.to raise_error(ArgumentError, /must inherit from AktionTest::Module::Base/)
    end

    it 'can load multiple modules at once' do
      define_class 'AnotherMod', AktionTest::Module::Base
      subject.use TestMod, AnotherMod
      subject.modules.map(&:class).should include(TestMod, AnotherMod)
    end
  end

  describe '#scope' do
    it 'allows temporarily changing the scope' do
      subject.scope 'TestScope' do
        subject.scope.should == %w(AktionTest Module TestScope)
      end
      subject.scope.should == %w(AktionTest Module)
    end

    it 'returns the current scope with no arguments' do
      subject.scope.should == %w(AktionTest Module)
    end

    it 'raises an ArgumentError if no block is given and a scope is named' do
      expect { subject.scope 'TestScope' }.to raise_error(ArgumentError, /block is required/)
    end

    it 'resets the scope even if an error occurs in the block' do
      begin
        subject.scope 'TestScope' do
          raise 'an error'
        end
      rescue
      end

      subject.scope.should == %w(AktionTest Module)
    end
  end
end
