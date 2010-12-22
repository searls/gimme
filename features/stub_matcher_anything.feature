Feature: stubbing with an anything matcher

  As a test author
  I want to be able to stub an invocation regardless of the arguments
  so that I don't need to redundantly stub things I don't care about

  Scenario Outline: stubbing
    Given a new Dog test double
    When I stub <method> to return <gives>
    Then invoking <invocation> returns <returns>
  
  Scenarios: a one-argument method
    | method                 | gives        | invocation            | returns      |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(Cat.new) | 'Why Hello!' |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(Dog.new) | 'Why Hello!' |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(nil)     | 'Why Hello!' |
  
  Scenarios: a two-argument method
    | method                     | gives    | invocation         | returns |
    | walk_to(anything,5)        | 'Park'   | walk_to(5,5)       | 'Park'  |
    | walk_to(anything,5)        | 'Park'   | walk_to('pants',5) | 'Park'  |
    | walk_to(anything,5)        | 'Park'   | walk_to(nil,5)     | 'Park'  |
    | walk_to(anything,5)        | 'Park'   | walk_to(3,5.1)     | nil     |
    | walk_to(3.123,anything)    | 'Park'   | walk_to(3.123,nil) | 'Park'  |    
    | walk_to(anything,anything) | 'Park'   | walk_to(3,5.1)     | 'Park'  |
    
  Scenarios: a variable-argument method (argument size must match; but I don't know if I like some of these…)
    | method                       | gives     | invocation               | returns |
    | eat(anything,:fish,anything) | :yum      | eat(:cat,:fish,:mouse)   | :yum    |  
    | eat(anything,:fish,anything) | :yum      | eat(:cat,:pants,:mouse)  | nil     |
    | eat(anything)                | :yum      | eat(:cat,:pants)         | nil     |      
    | eat(:cat,anything)           | :yum      | eat(:cat)                | nil     |
    | eat(:cat,anything)           | :yum      | eat(:cat,nil)            | :yum    |