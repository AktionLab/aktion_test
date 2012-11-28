require 'aktion_test/matchers/file_system/be_a_file'
require 'aktion_test/matchers/file_system/be_a_directory'
require 'aktion_test/matchers/file_system/directory_contains'
require 'aktion_test/matchers/file_system/file_contains'

module RSpec::Matchers
  include AktionTest::Matchers::FileSystem
end
