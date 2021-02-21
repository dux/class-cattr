module ClassCattr
  def self.included base
    def base.cattr name=nil
      if name
        Proxy.new(self).send(name)
      else
        Proxy.new(self)
      end
    end
  end

  def cattr name=nil
    if name
      Proxy.new(self.class).send(name)
    else
      Proxy.new(self.class)
    end
  end
end
