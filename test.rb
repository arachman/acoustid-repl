#!/usr/bin/env ruby

class A
  def initialize
    @a = nil
  end

  def foo
    puts "foo"
    self.bar
  end

  def bar
    puts "bar"
  end
end

a = A.new
a.foo
