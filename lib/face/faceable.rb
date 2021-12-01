module Face
  module Faceable
    # TODO: Needs clear_attr(name) methods
    # TODO: Raise an exception on the singleton methods if self.class == Face::Endpoint (it will pollute everything)

    # Defines an instance method and a class method,
    # where the class method sets the template for a thing
    # and the instance method uses that and extends it.
    # Fetched with get_attr(name, default_if_missing)
    def hash_attr(name)
      define_singleton_method name do |incoming|
        hash = instance_variable_get(:"@#{name}") || {}
        instance_variable_set(:"@#{name}", hash)
        hash.merge!(incoming)
        self
      end
      define_method name do |incoming|
        hash = get_attr(name, {})
        instance_variable_set(:"@#{name}", hash)
        hash.merge!(incoming)
        self
      end
    end
    module_function :hash_attr

    def stringish_attr(name)
      define_singleton_method name do |incoming|
        str = incoming || instance_variable_get(:"@#{name}")
        instance_variable_set(:"@#{name}", str)
        self
      end
      define_method name do |incoming|
        str = incoming || get_attr(name)
        instance_variable_set(:"@#{name}", str)
        self
      end
    end
    module_function :stringish_attr

    def self.extended(other)
      other.define_method :get_attr do |name, default = nil|
        instance_variable_get(:"@#{name}") || self.class.instance_variable_get(:"@#{name}").dup || default
      end
      other.send :stringish_attr, :url
      other.send :stringish_attr, :verb
    end
  end
end