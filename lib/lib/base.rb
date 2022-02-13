class Class
  def cattr name = nil, opts = {}, &block
    if name
      # cattr :foo, class: true, instance: true, default: proc { bar }

      unless opts.class == Hash
        raise ArgumentError, 'Options are not a Hash'
      end

      # if block provided, set it as a default value
      if block
        opts[:default] = block
      end

      # set class methods
      if opts[:class]
        define_singleton_method('%s=' % name) do |arg|
          CattrProxy.new(self).send('%s=' % name, arg)
        end

        define_singleton_method(name) do |arg = :_nil|
          if arg == :_nil
            CattrProxy.new(self).send(name)
          else
            CattrProxy.new(self).send('%s=' % name, arg)
          end
        end
      end

      # set instance methods
      if opts[:instance]
        define_method('%s=' % name) do |arg|
          CattrProxy.new(self.class).send('%s=' % name, arg)
        end

        define_method(name) do
          CattrProxy.new(self.class).send(name)
        end
      end

      # capture bad arguments
      supported = [:default, :class, :instance]
      invalid = opts.keys - supported
      if invalid.first
        raise ArgumentError, 'Invalid argument :%s, supported: %s' % [invalid.first, supported.join(', ')]
      end

      # set values
      CattrProxy.new(self).send('%s=' % name, opts[:default])
    else
      # Klass.cattr.foo

      CattrProxy.new(self)
    end
  end
end

class Object
  def cattr name=nil
    if name
      CattrProxy.new(self.class).send(name)
    else
      CattrProxy.new(self.class)
    end
  end
end
