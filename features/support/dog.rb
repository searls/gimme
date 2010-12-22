
# A simple class hierarchy declaring a few different types of methods on it that I can write cucumber features against something other than standard ruby classes/methods

module Eater
  def eat(*foods)
    #verify varargs
  end
end

class Animal
end

class Dog < Animal
  include Eater
    
  # to exercise stub & verify of attributes: matching(regex)
  attr_accessor :name
  
  def walk_to(x,y)
    'use me to exercise numeric matchers: numeric, less_than, greater_than, within_range'
  end

  def introduce_to(animal)
    'use me to exercise identity matchers: anything, is_a(Animal), is_a(Cat), any(Animal), any(Dog)'
  end
  
  def holler_at(loudly)
    'use me to exercise: boolean'
  end
  
  def use_toys(hash_of_toys_and_actions)
    'use me to exercise: hash_including'
  end
  
  def clean_toys(array_of_toys)
    'use me to exercise: including'
  end
  
  def purebred?
    'stub me to return a boolean'
  end
  
end

class Cat < Animal
end
