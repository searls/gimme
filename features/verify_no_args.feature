Feature: verification of no-arg methods
  
  As a test author
  I want to verify my test double's no-arg method was invoked
  So that I can specify its behavior
  
  Scenario:
    Given a new test double
    But I do not invoke to_s
    Then verifying to_s raises a Gimme::VerificationFailedError
    But I can verify to_s has been invoked 0 times

    When I invoke to_s
    Then I can verify to_s has been invoked
    And I can verify to_s has been invoked 1 time
        
    When I invoke to_s
    Then I can verify to_s has been invoked 2 times
    
    Then invoking gobbeldy_gook raises a NoMethodError
    And verifying gobbeldy_gook raises a NoMethodError