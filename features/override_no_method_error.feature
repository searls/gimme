Feature: overriding default NoMethodError for unknown methods

  As a test author
  I want to be able to stub and verify methods that aren't apparently on the class
  so that I can test behavior that I'm confident will be added to the test double's real counterpart dynamically
  
  Scenario: stubbing override
    Given a new Dog test double
    When I stub! meow to return :woof
    Then invoking meow returns :woof

  Scenario: verifying override
    Given a new Dog test double
    When I invoke meow
    Then I can verify! meow has been invoked 1 time    