class CattrProxy
  def initialize host
    @host = host
  end

  def method_missing key, value=nil, &block
    name = '@cattr_%s' % key

    if name.sub!(/=$/, '')
      @host.instance_variable_set name, value
    else
      if block_given?
        @host.instance_variable_set name, block
      else
        unless value.nil?
          raise ArgumentError, 'Plese use setter cattr.%s= to set argument' % key.to_s.sub('=', '')
        end

        for el in @host.ancestors
          if el.respond_to?(:superclass) && el != Object && el.instance_variable_defined?(name)
            value = el.instance_variable_get name
            value = value.call if value === Proc
            return value
          end
        end

        raise ArgumentError, 'Cattr class variable "cattr.%s" not defined on "%s".' % [name.sub('@cattr_', ''), @host]
      end
    end
  end
end
