require 'spec_helper'

describe AktionTest::Matchers::FileSystem::DirectoryExistanceMatcher do
  it "accepts an existing directory" do
    File.expand_path(File.join(__FILE__, '..')).should be_a_directory
  end

  it "does not accept a non-existant directory" do
    File.expand_path(File.join(__FILE__, '..', 'foo')).should_not be_a_directory
  end

  it "does not accept a file" do
    __FILE__.should_not be_a_directory
  end
end
