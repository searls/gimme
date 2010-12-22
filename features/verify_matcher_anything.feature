Feature: verify with an anything matcher

  As a test author
  I want to be able to verify an invocation replacing exact arguments with the anything matcher
  so that I'm able to specify only the parameters that matter to me
  
  Scenario: a single-argument
    Given a new Dog test double
    Then I can verify holler_at(anything) has been invoked 0 times
    When I invoke holler_at(false)
    Then I can verify holler_at(anything) has been invoked 1 time
    When I invoke holler_at(true)
    Then I can verify holler_at(anything) has been invoked 2 times
    
  Scenario: two arguments
    Given a new Dog test double
    Then I can verify walk_to(anything,anything) has been invoked 0 times    
    When I invoke walk_to(12.34,943.1)
    Then I can verify walk_to(anything,anything) has been invoked 1 time
    And I can verify walk_to(anything,943.1) has been invoked 1 time
    And I can verify walk_to(12.34,anything) has been invoked 1 time