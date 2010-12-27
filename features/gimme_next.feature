Feature: Gimme Next

  As a test author
  I want a test double to stand-in for the next new'ing of a given class
  so that I can isolate my SUT and stub & verify behavior of collaborators instantiated by the SUT

  Scenario:
    Given I create a double via gimme_next(Turtle)
    When my SUT tries creating a real Turtle.new(:shell)
    And I invoke swim
    Then both the double and real object reference the same object
    And I can verify! initialize(:shell) has been invoked 1 time
    And I can verify swim has been invoked 1 time