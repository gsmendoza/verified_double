# VerifiedDouble

[![Build Status](https://travis-ci.org/gsmendoza/verified_double.png)](https://travis-ci.org/gsmendoza/verified_double)

VerifiedDouble would record any mock made in the test suite. It
would then verify if the mock is valid by checking if there is a test
against it.

For example, let's say I mocked the save method of a model like so:

    item = VerifiedDouble.of_instance(Item)
    item.should_receive(:save).and_return(true)

Calling `VerifiedDouble.of_instance` would record the :save interaction on
item. When running the tests, the gem would look for a test that
confirms if you can indeed call #save on Item. The test should also
ensure that the method indeed returns a boolean value. Since this is hard
to automate, the gem would just look for a test with the tag saying it
verifies that contract:

    it "tests something", verifies_contract: 'Item#save => Boolean' do
      #...
    end

If this test does not exist, the gem would complain that the mock is not
verified.

This is an implementation of [contract tests](http://www.infoq.com/presentations/integration-tests-scam).
Notes about the presentation [here](http://www.beletsky.net/2010/10/agileee-2010-j-b-rainsberger-integrated.html).

There's already a gem that implements contract tests
([bogus](https://www.relishapp.com/bogus/bogus/v/0-0-3/docs/contract-tests)).
However, I think there's room for an alternative because:

1. It's not clear from the Bogus [documentation](https://www.relishapp.com/bogus/bogus/v/0-0-3/docs/contract-tests/contract-tests-with-mocks)
whether the gem verifies actual arguments/return values or just the types of those
values. While the argument/return types are enough in most cases, sometimes
the actual argument/return values are important. For example, if I mock
Item.where(conditions), the actual conditions are important in
verifying the validity of the where call.

2. [By design](https://www.relishapp.com/bogus/bogus/v/0-0-3/docs/fakes/faking-existing-classes#fakes-have-null-object-semantics),
a Bogus fake would return itself to all its methods. I prefer rspec-mock's
approach of raising an error if a method is not declared as part of the
double, since this raises errors earlier than later.

## Installation

Add this line to your application's Gemfile:

    gem 'verified_double'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install verified_double

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
