module StructuredApi
  module StructuredApiable
    # TODO: Needs clear_attr(name) methods
    # TODO: Raise an exception on the singleton methods if self.class == StructuredApi::Endpoint (it will pollute everything)

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
      define_singleton_method :"clear_#{name}" do
        instance_variable_set(:"@#{name}", {})
        self
      end
      define_method name do |incoming|
        hash = get_attr(name, {})
        instance_variable_set(:"@#{name}", hash)
        hash.merge!(incoming)
        self
      end
      define_method :"clear_#{name}" do
        instance_variable_set(:"@#{name}", {})
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
      define_singleton_method :"clear_#{name}" do
        instance_variable_set(:"@#{name}", '')
        self
      end
      define_method name do |incoming|
        str = incoming || get_attr(name)
        instance_variable_set(:"@#{name}", str)
        self
      end
      define_method :"clear_#{name}" do
        instance_variable_set(:"@#{name}", '') # TODO: replace with ->() {nil} maybe?
        self
      end
    end
    module_function :stringish_attr

    def self.extended(other)
      other.define_method :get_attr do |name, default = nil|
        instance_variable_get(:"@#{name}") ||
          self.class.ancestors.map { |x| x.instance_variable_get(:"@#{name}").dup }.compact.first ||
          default
      end
      other.send :stringish_attr, :url
      other.send :stringish_attr, :path
      other.send :stringish_attr, :verb
      other.send :hash_attr, :params
      other.send :hash_attr, :headers
      other.send :stringish_attr, :body
    end
  end
end
