Feature: Capturing Arguments

  As a test author
  I want to capture the value of an argument passed to my test double
  So that I can assert things about arguments my system under test passes to its collaborators
  
  Scenario: capturing an argument
    Given a new Dog test double
    And a new argument captor
    When I invoke holler_at(:panda)
    Then I can verify holler_at(capture(@captor)) has been invoked 1 time
    And the captor's value is :panda