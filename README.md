# Ruby class attributes

class-cattr gem provides simple way to set and get class attributes.

## Installation

to install

`gem install class-cattr`

or in Gemfile

`gem 'class-cattr'`

and to use

`require 'class-cattr'`

## How to use

* require 'class-cattr'
* define class attributes as `cattr :name, default: value, class: true|fase, instance: true|false`
* get them via `cattr.name` (or via class and instance method if provided)

```ruby
class AppModel
  # define :admin_path class attrbiute with class and instance methodss
  cattr :admin_path,
    # defaults value will be calculated on read, if proc provided
    default: proc { '/admin/%s' % to_s.tableize },
    
    # create class setter and getter
    class: true,
    
    # create instance setter and getter
    instance: true

  # :icon, default value is nil
  cattr :icon, 'undefined.png'
end

class User < AppModel
  cattr.icon = 'user.png'
end

class Product < AppModel
end

###

User.cattr.admin_path  # '/admin/people' (available allways)
User.admin_path        # '/admin/people' (from class: true)
@user.cattr.admin_path # '/admin/people' (available allways)
@user.admin_path       # '/admin/people' (from instance: true)

User.cattr.icon        # 'user.png'
User.icon              # NoMethodErorr
@user.cattr.icon       # 'user.png'
@user.icon             # NoMethodErorr

Product.cattr.icon     # 'undefined.png'
Product.icon           # NoMethodErorr
@product.cattr.icon    # 'undefined.png'
@product.icon          # NoMethodErorr
```

Tips

```ruby
class User
  cattr :icon, 'undefined.png'
  # can ve defined as
  cattr.icon = 'undefined.png'
  # but in this fashion you can't define class and instance setters and getters
  
  # this all all the same
  catr.time_now = proc { Time.now }
  catr(:time_now) { Time.now }
  catr :time_now, default: proc { Time.now }

  # you can define argument withut equal sign
  self.admin_path 'foo'
  # same as
  self.admin_path = 'foo'
end

# it is advice to define cattr with
cattr :name, opts

# and use via
Klass.cattr.name
@klass.cattr.name
```

## Q&A

Q: Why did you create this when Rails provides `class_attribute` ?
<br>
A: There is a small but nimble Ruby community that uses Ruby and outside the Rails eco-system.

Q: Why did you not use some and improve one of the existing similar libs?
<br>
A: I like clean interface without base class pollution, approach I did not find anywhre.
This gem only adds `cattr` methods to class and instance.
Optionaly, you can polute only class methods, you can pollute instance only methods, or both.

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
