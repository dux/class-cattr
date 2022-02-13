class CattrProxy
  def initialize host
    @host = host
  end

  def method_missing key, value = nil
    name = '@cattr_%s' % key

    if name.sub!(/=$/, '')
      @host.instance_variable_set name, value
    else
      unless value.nil?
        raise ArgumentError, 'Plese use setter cattr.%s= to set argument' % key
      end

      for el in @host.ancestors
        if el.respond_to?(:superclass) && el != Object && el.instance_variable_defined?(name)
          local = el.instance_variable_get name

          if local === Proc
            local = @host.instance_exec &local
          end

          return local
        end
      end

      raise ArgumentError, 'Cattr class variable "cattr.%s" not defined on "%s".' % [name.sub('@cattr_', ''), @host]
    end
  end
end
