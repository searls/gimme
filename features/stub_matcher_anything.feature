Feature: stubbing with an anything matcher

  As a test author
  I want to be able to stub an invocation regardless of the arguments
  so that I don't need to redundantly stub things I don't care about

  Scenario Outline: stubbing
    Given a new Dog test double
    When I stub <method> to return <stubbing>
    Then invoking <invocation> returns <returns>
  
  Scenarios: a one-argument method
    | method                 | stubbing     | invocation            | returns      |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(Cat.new) | 'Why Hello!' |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(Dog.new) | 'Why Hello!' |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(nil)     | 'Why Hello!' |
  
  Scenarios: a two-argument method
    | method              | stubbing | invocation         | returns |
    | walk_to(anything,5) | 'Park'   | walk_to(5,5)       | 'Park'  |
    | walk_to(anything,5) | 'Park'   | walk_to('pants',5) | 'Park'  |
    | walk_to(anything,5) | 'Park'   | walk_to(nil,5)     | 'Park'  |
    | walk_to(anything,5) | 'Park'   | walk_to(3,5.1)     | nil     |    
