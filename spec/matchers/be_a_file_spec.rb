require 'spec_helper'

describe AktionTest::Matchers::FileSystem::FileExistanceMatcher do
  it "should accept an existing file" do
    __FILE__.should be_a_file 
  end

  it "should not accept a non-existant file" do
    File.join(__FILE__, '..', 'foo').should_not be_a_file
  end

  it "should not accept a directory" do
    File.join(__FILE__, '..').should_not be_a_file
  end
end
