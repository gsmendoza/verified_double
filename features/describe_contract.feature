Feature: 10. Describe contract
  Scenario: Specify contact in describe string
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

      class SomeInput
      end

      class SomeOutput
      end
      """

    And the test suite is configured to use VerifiedDouble:

      """
      require 'verified_double'
      require 'verified_double/rspec_configuration'
      require 'main'
      """

    And a test that uses VerifiedDouble to mock an object:

      """
      require 'spec_helper'
      describe ObjectUnderTest do
        let(:input) { SomeInput.new }
        let(:output) { SomeOutput.new }
        let(:collaborator) { VerifiedDouble.of_instance('Collaborator') }

        it "tests something" do
          expect(collaborator)
            .to receive(:some_method).with(input).and_return(output)

          ObjectUnderTest.new.do_something(collaborator, input)
        end
      end
      """

    And the test suite has a contract test for the mock:

      """
      require 'spec_helper'

      describe Collaborator do
        context 'with some context' do
          describe '#some_method(SomeInput)=>SomeOutput', verifies_contract: true do
            it "tests something" do
              # do nothing
            end
          end
        end
      end
      """

    When I run the test suite
    Then I should not see any output saying the mock is unverified
