Feature: stubbing sensible defaults

  As a test author
  I want my test double to have some sensible defaults
  so that I do not find myself writing redundant/obvious stub code    
  
  Scenario:
    Given a new Dog test double
    Then invoking purebred? returns false

