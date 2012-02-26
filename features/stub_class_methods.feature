@wip
Feature: stubbing class methods

  In order to spec code that depends on Rails or other APIs that make
    liberal use of class methods, I want to stub class methods
    and see that the classes are restored after each spec run.


  Scenario Outline: stubbing class method
    Given the Possum class
    When I stub <method> to return <gives>
    Then invoking <invocation> returns <returns>

    When I reset Gimme
    Then <method> no longer returns <gives>

  Scenarios: the anything matcher with a one-argument method
    | method             | gives | invocation        | returns |
    | crawl_to(anything) | '…'   | crawl_to(Cat.new) | '…'     |
    | crawl_to(anything) | '…'   | crawl_to(Dog.new) | '…'     |
    | crawl_to(anything) | '…'   | crawl_to(nil)     | '…'     |
