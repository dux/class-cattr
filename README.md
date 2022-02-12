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
  cattr.foo = nil

  # define and set :foo class attributes
  cattr.foo = :bar

  # get :foo class attributes
  cattr.foo 

  # this will raise ArgumentError, class variable not defined
  foo

  # you can pass default value as a proc as well
  # on getter, value will be evalulated in runtime
  cattr.now { Time.now }

  # if you want to define class attribute that can be accessed directly without cattr proxy
  # define it by sending default value as a second paramter, or send a block
  # creates Foo.cattr.helper and Foo.helper
  cattr :helper, true
  # creates Foo.cattr.weather and Foo.weather
  cattr(:weather) { :rainy }
  # creates only Foo.cattr.color and Foo.color is not created
  cattr :color

  # set cattr.helper = :all
  helper = :all

  # get/read cattr.helper -> :all
  helper

  # you can ommit = when setting value
  # weather if -> :rainy
  weather :cloudy
  # weather is now -> :cloudy

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

## Q&A

* Q: Why did you create this when Rails provides `class_attribute` ?
  <br>
  A: There is a small but nimble Ruby community that uses Ruby and outside the Rails ekosystem. Yes they live.

* Q: Why did you not use some and improve one of the existing similar libs?
  <br>
  A: I like clean interface without base class pollution, approach I did not find anywhre.
  This gem only adds `cattr` methods to class and instance.
  You can polute class methods if you want, but you cant pollute object instance methods.

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
