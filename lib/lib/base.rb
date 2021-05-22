class Class
  def cattr name = nil, create_class_method = true
    if name && create_class_method == true
      define_singleton_method(name) do |arg = :_nil|
        if arg == :_nil
          CattrProxy.new(self).send(name)
        else
          CattrProxy.new(self).send('%s=' % name, arg)
        end
      end
    end

    if name
      CattrProxy.new(self).send('%s=' % name, nil)
    else
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
