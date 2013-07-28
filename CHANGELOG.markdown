0.4.0 - 2013-07-28
------------------

[#7] Pass: I should be able to use the RSpec's new expect syntax with
  VerifiedDouble.

[#7] Require verified_double/rspec_configuration in order to integrate
  verified_double with rspec.

[#18] Fix Scenario: stubbed doubles using hash syntax are no longer being
  recorded after 0.3.0.

[#19] Ensure: if `VerifiedDouble.of_instance(class_name, method_stubs={})` is
  used a argument or return value value of an expectation, then it should
  not interfere with the method signature recording of the expectation.

0.3.0 - 2013-07-19
------------------

* [#17] Major refactor: extend RSpec doubles with VerifiedDouble recording
  functionality. No more need for RecordingDouble.

0.2.0 - 2013-06-30
------------------

* [#4] Add stack frames and relish app link to output.
* [#12] RecordingDouble#class should be the class of the object being doubled.
* [#16] Fix handling of doubles passed as method signature values.

Known issues:

* Stack frames sometimes point to verified_double gem instead of where the mock was recorded.


0.1.1 - 2013-06-26
------------------

* Constantize should be a runtime dependency since constantize is used in
  VerifiedDouble::MethodSignatureValue.

* [#10] Fix VerifiedDouble::MethodSignatureValue#modified_class.
  If the value is an rspec double, the modified_class should be the class
  represented by the double's name.


0.1.0 - 2013-06-24
------------------

* [#3] Pass Scenario: Verifying mocks for accessors.
* [#3] Pass Scenario: Verifying mocks for readers
* [#5] Remove rspec-fire dependency.
* [#5] Use VerifiedDouble to mock and stub doubles in own tests.

0.0.2 - 2013-06-22
------------------

* Passes #1: Customizing arguments and return values.
* Set rspec-fire to 1.1 for the meantime.

0.0.1 - 2013-06-02
------------------

* Initial release. Passes "I want to be informed if the mocks I use are verified by contract tests" feature.


