require 'spec_helper'

###

class Class0
end

class ClassA < Class0
    include ClassCattr

  cattr.foo = 123
  cattr.now { Time.now }
  cattr.rand { rand() }

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
end

###

describe ClassCattr do
  it 'works with simple objects' do
    expect(ClassA.cattr.foo).to eq(123)
    expect(ClassB.cattr.foo).to eq(456)
  end

  it 'checks if block arguments work' do
    now1 = ClassB.cattr.rand.to_s
    now2 = ClassB.cattr.rand.to_s

    expect(now1 == now2).to eq(false)
  end

  it 'breaks on bad syntax' do
    expect { ClassB.cattr.test 123 }.to raise_error ArgumentError
  end

  it 'breaks when accessing undefined variable' do
    expect { Class0.cattr.test }.to raise_error NoMethodError
  end
end