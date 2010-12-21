Feature: basic stubbing

  As a test author
  I want to create a test double
  so that I can stub method returns
  
  Scenario:
    Given a new test double
    When I stub to_s to return "something"
    Then invoking to_s returns "something"
    
    Given a new Dog test double
    When I stub purebred? to return true
    Then invoking purebred? returns true
    