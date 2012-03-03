Feature: Default returns

  As a test author
  I want my test double to have some sensible defaults
  so that I do not find myself writing redundant/obvious stub code    
  
  Scenario: query? methods' default stubbing is false
    Given a new Dog test double
    Then invoking purebred? returns false
     And invoking walk_to(1,1) returns nil
