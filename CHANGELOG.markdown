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


