Feature: stubbing unknown methods

  As a test author
  I want my test double to yell at me when I try stubbing the class being doubled doesn't respond to
  so that I don't find myself with a green bar and a dependency that can't do what the test thinks it does.
  
  Scenario: stubbing an unknown method raises error
    Given a new Dog test double
    When I stub meow to return "Woof"
    Then a NoMethodError is raised

