Feature: Encountering Unknown Methods

  As a test author
  I want my test double to yell at me when I try invoking a method that instances of the class being doubled wouldn't respond to
  so that I don't find myself with a green bar and a dependency that can't do what the test thinks it does.
    
  However, I also want to be able to stub and verify methods that aren't apparently on the class
  so that I can test behavior that I'm confident will be added to the test double's real counterpart dynamically at runtime
  
  Scenario: stubbing an unknown method raises a NoMethodError error
    Given a new Dog test double
    When I stub meow to return "Woof"
    Then a NoMethodError is raised

  Scenario: verifying an unknown method raises NoMethodError error    
    Given a new Dog test double
    When I invoke gobbeldy_gook
    Then verifying gobbeldy_gook raises a NoMethodError    

  Scenario: stubbing a method with "give!" suppresses the error
    Given a new Dog test double
    When I stub! meow to return :woof
    Then invoking meow returns :woof

  Scenario: verifying a method with "verify!" suppresses the error
    Given a new Dog test double
    When I invoke meow
    Then I can verify! meow has been invoked 1 time