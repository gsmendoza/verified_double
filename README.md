# VerifiedDouble

[![Build Status](https://travis-ci.org/gsmendoza/verified_double.png)](https://travis-ci.org/gsmendoza/verified_double)

VerifiedDouble is a gem for verifying rspec mocks. The gem works similar to [rspec-fire](https://github.com/xaviershay/rspec-fire). However, instead of checking if a doubled class responds to the methods, the gem looks for tests confirming the signatures of the mocks.

For example, if I mock the created_at method of a model like this:

```ruby
item = VerifiedDouble.of_instance(Item)
expect(item).to receive(:created_at).and_return(Time.now)
```

When I run the tests, the gem will look for a "contract test" tagged with the method's signature. This test should ensure that calling `#created_at` on Item will return a Time object.

```ruby
describe Item do
  describe '#created_at()=>Time', verifies_contract: true do
    it "tests something" do
      #...
    end
  end
end
```

If this test does not exist, the gem will complain that the mock is not verified.

I got the idea from http://www.infoq.com/presentations/integration-tests-scam, an old (2009) talk that still has some fresh insights on dealing with API changes in your mocked tests.

## Setup

Require `verified_double/rspec_configuration` in your spec_helper.rb to integrate VerifiedDouble with rspec. If you want verified_double to be run only as needed, create a separate verified_spec_helper.rb:

```
# spec/verified_spec_helper.rb
require 'spec_helper'
require 'verified_double/rspec_configuration'
```

And require it when running rspec:

    rspec -r ./spec/verified_spec_helper.rb

## Usage

Let's look again at the example above:

```ruby
item = VerifiedDouble.of_instance(Item)
expect(item).to receive(:created_at).and_return(Time.now)
```

When you run this test, you'll see a warning saying that there's no test verifying the mock `Item#created_at()=>Time`:

```
The following mocks are not verified:

1. Item#created_at()=>Time
...

```

You can then tag the test for `Item#created_at()=>Time` with the method signature:

```ruby
describe Item do
  describe '#created_at()=>Time', verifies_contract: true do
    it "tests something" do
      #...
    end
  end
end
```

Take note that:

1. The described class must be a class, not a string.
2. The described method must start with `#` if its an instance method and `.` if it's a class method.
3. You need to add the add the `verifies_contract: true` tag to the test.

If your testing style doesn't follow these conventions, you can tag the test with the whole method signature:

```ruby
describe 'Item' do
  it "has a creation timestamp", verifies_contract: `Item#created_at()=>Time` do
    #...
  end
end
```

Since VerifiedDouble relies on tags to link mocks and contracts together, you'll
need to run the tests containing the contracts along with tests with the mocks in
order to clear the VerifiedDouble warnings.

## Booleans

Since Ruby doesn't have Boolean class covering both `TrueClass` and `FalseClass`,
VerifiedDouble supplies its own `VerifiedDouble::Boolean` class. Thus if your method
accepts or returns a boolean value, you'll see `VerifiedDouble::Boolean` in its
method signature e.g. `Student.late?()=>VerifiedDouble::Boolean`.

## Helpers

Most of the time, you'll be mocking accessor methods. VerifiedDouble provides some
helpers to make them easy to verify.

For reader methods, there's the `verify_reader_contract` matcher. The matcher checks
if the method will return an object matching the class specified by the contract:

```ruby
class Collaborator
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

class SomeValue
end

describe Collaborator do
  subject { described_class.new(SomeValue.new) }
  it { should verify_reader_contract('Collaborator#value=>SomeValue') }
end
```

For accessor methods, there's the `verify_accessor_contract` matcher. The matcher
instantiates the return class and tries to pass and retrieve the value
to the method:

```ruby
class Collaborator
  attr_accessor :value
end

describe Collaborator do
  it { should verify_accessor_contract('Collaborator#value=>SomeValue') }
end
```

## Any Instance mocks

Aside for instance and class doubles, VerifiedDouble also supports `any_instance` mocks:

```
VerifiedDouble.any_instance_of(Collaborator)
  .should_receive(:some_method).with(input).and_return(output)
```

You'll need to use should_receive for `any_instance` mocks. I still have to figure
out how to make it work with RSpec's `expect_any_instance_of` syntax :p

## Complete documentation

You can learn more about using the gem at https://www.relishapp.com/gsmendoza/verified-double.

## Actively tested against

* Ruby 2.0
* RSpec 2.14

## Alternatives

[Bogus](https://www.relishapp.com/bogus/bogus/v/0-0-3/docs/) is the first gem I know to implement contract tests. It doesn't rely on rspec tags to verify contracts, so it's probably a lot smarter than VerifiedDouble :) However, I wasn't able to try it out on my own projects because of its own rr-like mock adapter. But do check it out!

## Special thanks

* [Inner Core Designs](http://icdesign.com.au)
* [Love With Food](https://lovewithfood.com)
