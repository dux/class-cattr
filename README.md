# Class attributes

class-cattr gem provides simple way to set and get class attributes.

## Installation

to install

`gem install class-cattr`

or in Gemfile

`gem 'class-cattr'`

and to use

`require 'class-cattr'`

## How to use

* include `ClassCattr`
* define class attributes as `cattr.name = value`
* get them via `cattr.name` (class and instance method provided)

```ruby
class Foo
  # define :foo variable with nil value
  cattr :foo

  # define and set :foo class attributes
  cattr.foo = :bar

  # get :foo class attributes
  cattr.foo 

  # you can pass value as a block
  cattr.now { Time.now }

  # define class varaible by sending true
  cattr :helper, true

  # set cattr.helper = :all
  helper :all

  # cattr.helper
  helper

  def test
    # get :foo class attributes
    cattr.foo

    # if value block is called in current scope in time of calling
    cattr.now
  end
end

class Bar < Foo
  cattr.foo = 123
end

Foo.cattr.foo # :bar
Bar.cattr.foo # 123
Bar.cattr.now # proc { Time.now }.call
```

## Dependency

none

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rspec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dux/class-cattr.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
