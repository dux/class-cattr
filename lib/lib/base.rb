class Class
  def cattr name=nil
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
