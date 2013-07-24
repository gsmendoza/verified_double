# VerifiedDouble

[![Build Status](https://travis-ci.org/gsmendoza/verified_double.png)](https://travis-ci.org/gsmendoza/verified_double)

VerifiedDouble is a gem for verifying rspec mocks. The gem works similar to [rspec-fire](https://github.com/xaviershay/rspec-fire). However, instead of checking if the doubled classes respond to the methods, the gem looks for tests confirming if those mocks are valid.

For example, let's say I mocked the created_at method of a model like this:

    item = VerifiedDouble.of_instance(Item)
    expect(item).to receive(:created_at).and_return(Time.now)

When running the tests, the gem looks for a "contract test" tagged with the method's signature. This test should ensure that calling #created_at on Item will return a Time object.

    it "tests something", verifies_contract: 'Item#created_at()=>Time' do
      #...
    end

If this test does not exist, the gem will complain that the mock is not verified.

I got the idea from http://www.infoq.com/presentations/integration-tests-scam, an old (2009) talk that still has some fresh insights on dealing with API changes in your mocked tests.

You can learn more about using the gem at https://www.relishapp.com/gsmendoza/verified-double.

Actively tested against
-----------------------

* Ruby 1.9.3
* RSpec 2.13


Alternatives
------------

[Bogus](https://www.relishapp.com/bogus/bogus/v/0-0-3/docs/) is the first gem to implement contract tests. It doesn't rely on rspec tags to verify contracts, so it's probably a lot smarter than VerifiedDouble :) However, I wasn't able to try it out on my own projects because of its own rr-like mock adapter. But do check it out!

Caveats
-------

VerifiedDouble is still in its infancy, but I hope it's usable for the most common cases.

* With 0.3.0, doubles created with VerifiedDouble.of_instance() and VerifiedDouble.of_class() are now VerifiedDouble-extended RSpec doubles. As a result, they should function like regular RSpec doubles. However, VerifiedDouble still doesn't have support for [RSpec mock argument matchers](https://github.com/rspec/rspec-mocks#argument-matchers). Please post an issue at http://github.com/gsmendoza/verified_double if you need support for any particular rspec-mock API.

* The [method documentation](http://rubydoc.info/gems/verified_double) is pretty empty at this point :p I'm planning to use yard-spec to document the methods but that gem doesn't support rspec context blocks. I'll try to work on that soon.

Special thanks
--------------

To [Thomas Sinclair](https://twitter.com/anathematic) and [Inner Core Designs](http://icdesign.com.au) for sponsoring this gem :)
