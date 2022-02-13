require 'spec_helper'

###

class Class0
end

class ClassA < Class0
  cattr.simple_set = true
  
  cattr :foo, default: 123
  cattr :bar
  cattr :now, default: proc { Time.now}, instance: true
  cattr :rand, default: proc { rand() }

  cattr :inst, instance: true

  cattr :helper, class: true
  cattr :weather, default: proc { :rainy }, class: true

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

  self.helper = :use_it
  self.weather = :cloudy
  
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

  it 'sets instance method get' do
    expect(ClassA.new.now.to_i).to eq(Time.now.to_i)
    expect(ClassB.new.now).to eq(:bar)
  end

  it 'sets instance method set' do
    ClassA.new.inst = :a
    ClassB.new.inst = :b
    expect(ClassA.new.inst).to eq(:a)
    expect(ClassB.new.inst).to eq(:b)
  end

  it 'expects simple set to work' do
    expect{ Class0.cattr.simple_set}.to raise_error(ArgumentError)
    expect(ClassA.cattr.simple_set).to eq(true)
    expect(ClassB.cattr.simple_set).to eq(true)
  end

  it 'captures invalid argument' do
    expect{ ClassA.cattr(:bad, foo: true) }.to raise_error(ArgumentError)
  end

  it 'can set arg in class method' do
    ClassA.cattr :arg_setter, class: true

    value = 123
    ClassA.arg_setter value
    expect(ClassA.arg_setter).to eq(value)
    expect(ClassA.cattr.arg_setter).to eq(value)
  end
end