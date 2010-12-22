Feature: stubbing with matchers

  As a test author
  I want to be able to stub an invocation based on matchers' evaluations of the arguments
  so that I don't need to redundantly stub things I don't care about

  Scenario Outline: stubbing
    Given a new Dog test double
    When I stub <method> to return <gives>
    Then invoking <invocation> returns <returns>
  
  Scenarios: the anything matcher with a one-argument method
    | method                 | gives        | invocation            | returns      |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(Cat.new) | 'Why Hello!' |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(Dog.new) | 'Why Hello!' |
    | introduce_to(anything) | 'Why Hello!' | introduce_to(nil)     | 'Why Hello!' |
  
  Scenarios: the anything matcher with a two-argument method
    | method                     | gives  | invocation         | returns |
    | walk_to(anything,5)        | 'Park' | walk_to(5,5)       | 'Park'  |
    | walk_to(anything,5)        | 'Park' | walk_to('pants',5) | 'Park'  |
    | walk_to(anything,5)        | 'Park' | walk_to(nil,5)     | 'Park'  |
    | walk_to(anything,5)        | 'Park' | walk_to(3,5.1)     | nil     |
    | walk_to(3.123,anything)    | 'Park' | walk_to(3.123,nil) | 'Park'  |
    | walk_to(anything,anything) | 'Park' | walk_to(3,5.1)     | 'Park'  |
    
  Scenarios: the anything matcher with a variable-argument method (argument size must match; but I don't know if I like some of these…)
    | method                       | gives | invocation              | returns |
    | eat(anything,:fish,anything) | :yum  | eat(:cat,:fish,:mouse)  | :yum    |
    | eat(anything,:fish,anything) | :yum  | eat(:cat,:pants,:mouse) | nil     |
    | eat(anything)                | :yum  | eat(:cat,:pants)        | nil     |
    | eat(:cat,anything)           | :yum  | eat(:cat)               | nil     |
    | eat(:cat,anything)           | :yum  | eat(:cat,nil)           | :yum    |
    
  Scenarios: the numeric matcher
  | method                   | gives    | invocation              | returns  |
  | walk_to(numeric,numeric) | :hydrant | walk_to(1.498,8)        | :hydrant |
  | walk_to(numeric,numeric) | :hydrant | walk_to(1.498,'string') | nil      |
  | walk_to(numeric,numeric) | :hydrant | walk_to(1.498,nil)      | nil      |

  Scenarios: the is_a matcher
  | method                     | gives  | invocation               | returns |
  | introduce_to(is_a(Animal)) | :howdy | introduce_to(Animal.new) | :howdy  |
  | introduce_to(is_a(Animal)) | :howdy | introduce_to(Cat.new)    | :howdy  |
  | introduce_to(is_a(Animal)) | :howdy | introduce_to(Object.new) | nil     |
  | introduce_to(is_a(Animal)) | :howdy | introduce_to(nil)        | nil     |

  Scenarios: the any matcher (like is_a but also matches nil)
  | method                     | gives  | invocation               | returns |
  | introduce_to(any(Animal)) | :howdy | introduce_to(Animal.new) | :howdy  |
  | introduce_to(any(Animal)) | :howdy | introduce_to(Cat.new)    | :howdy  |
  | introduce_to(any(Animal)) | :howdy | introduce_to(Object.new) | nil     |
  | introduce_to(any(Animal)) | :howdy | introduce_to(nil)        | :howdy  |
