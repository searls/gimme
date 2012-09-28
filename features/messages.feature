Feature: messages from test doubles

  Test doubles need to output sufficient messages
    (particularly on failure)

  Scenario: inspect/to_s for arguments
    Given we have this production code:
      """
      class Chair
      end

      class Person
        def
         sit_on(thing)
        end
      end
      """
    When we write a test we expect to fail:
      """
      chair = gimme(Chair)
      person = gimme(Person)

      person.sit_on() #<--oops! forgot the chair

      verify(person).sit_on(chair)
      """
    Then we should see a failure message that includes:
      """
      expected Person#sit_on to have been called with arguments [<#Gimme:1 Chair>]
      """
    Then we should see a failure message that includes:
      """
      was actually called 1 times with arguments []
      """

  Scenario: naming mocks
    Given we have this production code:
      """
      class Panda
      end
      """
    Then this should work:
      """
      gimme(Panda).to_s.should == "<#Gimme:1 Panda>"
      gimme(Panda).inspect.should == "<#Gimme:2 Panda>"
      gimme("a bear thing").inspect.should == "<#Gimme:3 a bear thing>"
      """