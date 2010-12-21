Feature: verification of argumentative methods
  
  As a test author
  I want to verify my test double's argument-having method was invoked
  So that I can specify the exact arguments
  
  Scenario: 
    Given a new test double
    But I do not invoke equal?(:pants)
    Then verifying equal?(:pants) raises a Gimme::VerificationFailedError
    But I can verify equal?(:pants) has been invoked 0 times

    When I invoke equal?(:pants)
    Then I can verify equal?(:pants) has been invoked    
    And I can verify equal?(:pants) has been invoked 1 time
    And I can verify equal?(:kaka) has been invoked 0 times
        
    When I invoke equal?(:pants)
    And I invoke equal?(:kaka)    
    Then I can verify equal?(:kaka) has been invoked 1 time
    And I can verify equal?(:pants) has been invoked 2 times