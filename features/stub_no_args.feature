Feature: stubbing

  As a test author
  I want to create a test double
  so that I can stub method returns
  
  Scenario:
    Given a new test double
    When I stub to_s to return "something"
    Then invoking to_s returns "something"