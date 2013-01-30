require 'spec_helper'

describe AktionTest::Support::ClassBuilder do
  it "creates a new class" do
    clazz = define_class('Foo')
    clazz.new.should be_a Foo
  end

  it "creates a new class with a base" do
    base = define_class('Foo')
    clazz = define_class('Bar', Foo)
    clazz.superclass.should == Foo
  end

  it "creates a new class and class evals a block" do
    clazz = define_class('Foo') do
      class << self
        def foo
          "baz"
        end
      end

      attr_accessor :bar
    end

    clazz.foo.should == 'baz'
    clazz.new.should respond_to :bar
    clazz.new.should respond_to :bar=
  end
end
