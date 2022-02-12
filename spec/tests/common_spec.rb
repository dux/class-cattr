require 'spec_helper'

###

class Class0
end

class ClassA < Class0
  cattr.foo = 123
  cattr :bar
  cattr.now { Time.now }
  cattr.rand { rand() }

  cattr :helper, nil
  cattr(:weather) { :rainy }

  def get_foo
    cattr.foo
  end

  def get_now
    cattr.now
  end
end

class ClassB < ClassA
  cattr.foo = 456
  cattr.now = :bar

  helper :use_it
  weather :cloudy

  def get_foo
    cattr.foo
  end
end

###

describe CattrProxy do
  it 'works with simple objects' do
    expect(ClassA.cattr.foo).to eq(123)
    expect(ClassB.cattr.foo).to eq(456)
  end

  it 'checks if block arguments work' do
    now1 = ClassB.cattr.rand.to_s
    now2 = ClassB.cattr.rand.to_s

    expect(ClassB.cattr.rand.class).to eq(Float)
    expect(ClassA.cattr.now.class).to eq(Time)
    expect(now1 == now2).to eq(false)
  end

  it 'gets values from instance variables' do
    expect(ClassA.new.get_foo).to eq(123)
    expect(ClassB.new.get_foo).to eq(456)
  end

  it 'breaks on bad syntax' do
    expect { ClassB.cattr.test 123 }.to raise_error ArgumentError
  end

  it 'creats class method' do
    expect(ClassA.helper).to eq(nil)
    expect(ClassB.helper).to eq(:use_it)
    expect(ClassA.weather).to eq(:rainy)
    expect(ClassB.weather).to eq(:cloudy)
  end

  it 'breaks when accessing undefined variable' do
    expect { Class0.cattr.test }.to raise_error ArgumentError
  end

  it 'can reset value' do
    expect { ClassA.cattr.weather = 123 }.not_to raise_error
    expect { ClassA.weather = 123 }.not_to raise_error
  end

  it 'cant reset value' do
    expect { ClassA.foo = 123 }.to raise_error NoMethodError
  end
end