Feature: basic stubbing

  As a test author
  I want to create a test double
  so that I can stub method returns

  Scenario Outline: stubbing
    Given a new Dog test double
    When I stub <method> to return <gives>
    Then invoking <invocation> returns <returns>
  
  Scenarios: no-arg methods
    | method    | gives       | invocation | returns     |
    | to_s      | 'something' | to_s       | 'something' |
    | purebred? | true        | purebred?  | true        |
    
  Scenarios: one-arg methods
    | method          | gives | invocation        | returns |
    | holler_at(true) | :ruff | holler_at(true)   | :ruff   |
    | holler_at(true) | :ruff | holler_at(false)  | nil     |
    | holler_at(true) | :ruff | holler_at(:panda) | nil     |
    | holler_at(true) | :ruff | holler_at(nil)    | nil     |
    
  Scenarios: two-arg methods
    | method               | gives | invocation           | returns |
    | walk_to(1,2)         | :park | walk_to(1,2)         | :park   |
    | walk_to(1,2)         | :park | walk_to(0.9,2)       | nil     |
    | walk_to(1,2)         | :park | walk_to(1,2.1)       | nil     |
    | walk_to([1,5],[2,7]) | :park | walk_to([1],[5,2,7]) | nil     |
    
    
