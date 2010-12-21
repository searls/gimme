Feature: stubbing with an anything matcher

  As a test author
  I want to be able to stub an invocation regardless of the arguments
  so that I don't need to redundantly stub things I don't care about
  
  Scenario:
    Given a new Dog test double
    When I stub introduce_to(anything) to return 'Why Hello!'
    Then invoking introduce_to(Cat.new) returns 'Why Hello!'
    And invoking introduce_to(Dog.new) returns 'Why Hello!'
    And invoking introduce_to(nil) returns 'Why Hello!'    

    When I stub walk_to(anything,5) to return 'Park'
    Then invoking walk_to(5,5) returns 'Park'
    And invoking walk_to('pants',5) returns 'Park'
    And invoking walk_to(nil,5) returns 'Park'    