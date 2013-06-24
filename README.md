# VerifiedDouble

[![Build Status](https://travis-ci.org/gsmendoza/verified_double.png)](https://travis-ci.org/gsmendoza/verified_double)

VerifiedDouble verifies mocks made in the test suite by checking if there are tests against them.

For example, let's say I mocked the created_at method of a model like this:

    item = VerifiedDouble.of_instance(Item)
    item.should_receive(:created_at).and_return(Time.now)

The item double records its :created_at call. When
running the tests, the gem looks for a test that confirms if you can
indeed call #created_at on Item. The test should also ensure that the method
returns a Time object. Since this is hard to automate, the gem just looks
for a test with a tag saying it verifies that contract:

    it "tests something", verifies_contract: 'Item#created_at()=>Time' do
      #...
    end

If this test does not exist, the gem will complain that the mock is not
verified.

More information at https://www.relishapp.com/gsmendoza/verified-double.

References
----------

1. http://www.confreaks.com/videos/2452-railsconf2013-the-magic-tricks-of-testing
2. https://www.relishapp.com/bogus/bogus/v/0-0-3/docs/contract-tests
3. http://www.infoq.com/presentations/integration-tests-scam

Special thanks
--------------

To @anathematic and [Inner Core Designs](http://icdesign.com.au) for sponsoring this gem :)
