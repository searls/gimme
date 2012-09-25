Feature: messages from test doubles

  Test doubles need to output sufficient messages on failure

  Scenario: argument inspects
    Given we have this existing code:
      """
      class Chair
      end

      class Person
        def sit_on(thing)
        end
      end
      """
    When we write a test we expect to fail:
      """
      chair = gimme(Chair)
      person = gimme(Person)

      person.sit_on(chair)

      verify(person).sit_on()

      chair.should == chair
      """
    Then we should see a failure message that includes:
      """
      expected Person#sit_on to have been called with arguments [#<Gimme:Chair:0>]
      """
