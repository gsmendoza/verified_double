Feature: Rspec Mock compatibility
  As a developer
  I want VerifiedDouble to work with Rspec Mock API

  Background:
    Given the following classes:
      """
      class ObjectUnderTest
        def do_something(collaborator, input)
          collaborator.some_method(input)
        end

        def do_something_twice(collaborator, input)
          collaborator.some_method(input)
          collaborator.some_method(input)
        end
      end

      class Collaborator
        def some_method(input)
        end
      end

      class SomeError < Exception
      end

      class SomeInput
      end

      class SomeOutput
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(SomeInput)=>SomeOutput' do
          # do nothing
        end
      end
      """

    And the test suite has an after(:suite) callback asking VerifiedDouble to report unverified doubles:
      """
      require 'verified_double'
      require 'main'

      RSpec.configure do |config|
        config.after :suite do
          VerifiedDouble::ReportUnverifiedSignatures.new(VerifiedDouble.registry, self).execute
        end
      end
      """

  Scenario: once
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).once.and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified

  Scenario: twice
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).twice.and_return(output)
          ObjectUnderTest.new.do_something_twice(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified

  Scenario: exactly
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).exactly(1).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified

  Scenario: at_least
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).at_least(:once).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified

  Scenario: at_most
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).at_most(:once).and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified

  Scenario: any_number_of_times
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).any_number_of_times.and_return(output)
          ObjectUnderTest.new.do_something(instance_double, input)
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified

  Scenario: and_raise
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:error) { SomeError.new }
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).and_raise(error)
          expect { ObjectUnderTest.new.do_something(instance_double, input) }.to raise_error(error)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(SomeInput)' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified
  Scenario: and_throw
    Given a test that uses VerifiedDouble to mock an object:
      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:error_symbol) { :error_symbol }
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:instance_double) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          instance_double.should_receive(:some_method).with(input).and_throw(error_symbol)
          expect { ObjectUnderTest.new.do_something(instance_double, input) }.to throw_symbol(error_symbol)
        end
      end
      """

    And the test suite has a contract test for the mock:
      """
      require 'spec_helper'

      describe 'Collaborator' do
        it "tests something", verifies_contract: 'Collaborator#some_method(SomeInput)' do
          # do nothing
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the stub is unverified