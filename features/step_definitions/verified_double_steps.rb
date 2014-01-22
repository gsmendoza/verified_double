Given /^the following classes:$/ do |string|
  write_file 'lib/main.rb', string
end

Given /^a test that uses VerifiedDouble to mock an object:$/ do |string|
  write_file 'spec/main_spec.rb', string
end

Given(/^a test that uses VerifiedDouble to mock any instance of the class:$/) do |string|
  write_file 'spec/main_spec.rb', string
end

Given /^a test that uses VerifiedDouble to mock the object under test:$/ do |string|
  write_file 'spec/main_spec.rb', string
end

Given "a test that uses both rspec-mock and VerifiedDouble to partially mock a " +
  "class:" do |string|

  write_file 'spec/main_spec.rb', string
end

Given /^a test that uses VerifiedDouble to stub an object:$/ do |string|
  write_file 'spec/main_spec.rb', string
end

Given(/^a test that uses VerifiedDouble to stub any instance of the class:$/) do |string|
  write_file 'spec/main_spec.rb', string
end

Given /^a test that uses VerifiedDouble to mock a class:$/ do |string|
  write_file 'spec/main_spec.rb', string
end

Given /^the test suite has a contract test for the mock:$/ do |string|
  write_file 'spec/contract_test_for_main_spec.rb', string
end

Given /^the test suite has a contract test for the stub:$/ do |string|
  write_file 'spec/contract_test_for_main_spec.rb', string
end

Given /^the test suite has another test mocking the class with rspec\-mock:$/ do |string|
  write_file 'spec/another_spec.rb', string
end

Given /^the test suite is configured to use VerifiedDouble:$/ do |string|
  write_file 'spec/spec_helper.rb', string
end

Given /^the test suite does not have a contract test for the mock$/ do
  # do nothing
end

Given /^the test suite does not have a contract test for the stub$/ do
  # do nothing
end

When /^I run the test suite$/ do
  run_simple(unescape("rspec"), false)
end

Then /^I should be informed that the mock is unverified:$/ do |string|
  assert_partial_output(string, all_output)
  assert_success('pass')
end

Then /^I should be informed that the stub is unverified:$/ do |string|
  assert_partial_output(string, all_output)
  assert_success('pass')
end

Then "I should be informed that only the VerifiedDouble\.wrap mock is " +
  "unverified:" do |string|

  assert_partial_output(string, all_output)
  assert_success('pass')
end

Then /^I should not see any output saying the mock is unverified$/ do
  assert_no_partial_output("The following mocks are not verified", all_output)
  assert_success('pass')
end

Then /^I should not see any output saying the stub is unverified$/ do
  assert_no_partial_output("The following mocks are not verified", all_output)
  assert_success('pass')
end
