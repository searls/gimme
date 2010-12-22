Feature: verify with an anything matcher

  As a test author
  I want to be able to verify an invocation replacing exact arguments with the anything matcher
  so that I'm able to specify only the parameters that matter to me
  
  Scenario: a single-argument
    Given a new Dog test double
    When I invoke holler_at(false)
    Then I can verify holler_at(anything) has been invoked 1 time
