Feature: 04. Customizing arguments and return values
  As a developer
  I want the ability to make contract arguments and return values more or less specific

  Background:
    Given the following classes:
      """
      class ObjectUnderTest
        def do_something(collaborator, input)
          collaborator.some_method(input)
        end
      end

      class Collaborator
        def some_method(input)
        end
      end
      """

    And the test suite has an after(:suite) callback asking VerifiedDouble to report unverified doubles:
      """
      require 'verified_double'
      require 'main'

      RSpec.configure do |config|
        config.after :suite do
          VerifiedDouble.report_unverified_signatures(self)
        end
      end
      """

    And a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { :input }
        let(:output) { :output }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

  Scenario: More general argument
    Given the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(Object)=>Symbol' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: More specific argument
    Given the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(:input)=>Symbol' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: More general return value
    Given the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(Symbol)=>Object' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified

  Scenario: More specific return value
    Given the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(Symbol)=>:output' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified
