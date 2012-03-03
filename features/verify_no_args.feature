Feature: verification of no-arg methods

  As a test author
  I want to verify my test double's no-arg method was invoked
  So that I can specify its behavior

  Scenario:
    Given a new test double
    But I do not invoke yawn
    Then verifying yawn raises a Gimme::Errors::VerificationFailedError
    But I can verify yawn has been invoked 0 times

    When I invoke yawn
    Then I can verify yawn has been invoked
    And I can verify yawn has been invoked 1 time

    When I invoke yawn
    Then I can verify yawn has been invoked 2 times

  @wip
  Scenario: class methods
    Given the ClassyPossum class
    When I spy on ClassyPossum.yawn
    Then it can verify no-arg methods too.