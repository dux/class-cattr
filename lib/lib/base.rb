class Class
  def cattr name = nil, value = :_nil, &block
    return CattrProxy.new(self) unless name

    if value != :_nil || block
      define_singleton_method(name) do |arg = :_nil|
        if arg == :_nil
          CattrProxy.new(self).send(name)
        else
          CattrProxy.new(self).send('%s=' % name, arg)
        end
      end

      if value != :_nil
        CattrProxy.new(self).send('%s=' % name, value)
      elsif block
        CattrProxy.new(self).send(name, value, &block)
      end
    else
      CattrProxy.new(self).send('%s=' % name, nil)
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
