class MyBaseClass
  class << self
    def foo
      'foo'
    end

    def method_missing(method, *args, &block)
      self.class.send(:define_method, method) do
        "You called #{method} on #{self}"
      end

      send(method, *args, &block)
    end

    def respond_to_missing?(_method, _include_private = false)
      true
    end
  end
end

# ask the user for a class name
user_class_name = 'Test'

# dynamically create a class
klass = Object.const_set(user_class_name, Class.new(MyBaseClass))

p klass.foo

klass.instance_eval do
  def bar
    'bar'
  end
end

p MyBaseClass.test_class
# You called test_class on MyBaseClass

p klass.test_class
# You called test_class on MyBaseClass::Test

p klass.bar
# bar

p MyBaseClass.bar
# You called bar on MyBaseClass
