Feature: argument matchers

  By default, gimme will only stub and verify methods that are called with the same arguments
    in your spec and your production code. But gimme also includes a number of argument matchers
    that allow more flexible specifications, particularly when you don't care about or can't
    know the <em>exact</em> arguments passed to a method on a test double.

  This example illustrates:
    <ul>
      <li>How to use an argument matcher when stubbing a method</li>
      <li>Using argument matchers when verifying a method</li>
      <li>Using argument captors, a special sort of matcher</li>
      <li>Defining your own matcher</li>
    </ul>

  In this example, we have a Mail object with a contents attribute. A DeliversMessages object adds Mail to
    Recipients' mailboxes and checks off each delivery on its Checklist.


  Background:
    Given we have this existing code:
      """
      class Mail
        attr_reader :contents
        def initialize(contents)
          @contents = contents
        end
      end

      class Recipient
        def add_to_mailbox(thing)
        end
      end

      class Checklist
        def check_off(message_summary, recipient, timestamp)
        end
      end

      class DeliversMessages
        def initialize(checklist = Checklist.new)
          @checklist = checklist
        end
      end
      """
    When we want to write some tests to help us write this method:
      """
      class DeliversMessages
        def deliver(message, recipient = Recipient.new)
          mail = Mail.new(message)
          recipient.add_to_mailbox(mail)
          @checklist.check_off(message[0..4], recipient, Time.now)
        end
      end
      """

  Scenario: stubbing with argument matchers
    Then we can use gimme to isolate the unit under test:
      """
      # pretend we want to ensure the #deliver function returns
      #   whatever the Checlist#check_off method returns. We can
      #   specify that by stubbing the check_off method
      checklist = gimme(Checklist)
      recipient = gimme(Recipient)
      give(checklist).check_off(anything, anything, is_a(Time)) { "Pandas!" }

      result = DeliversMessages.new(checklist).deliver("WHY HELLO GOOD SIR", recipient)

      result.should == "Pandas!"
      """

  Scenario: using some built-in matchers
    Then we can use gimme to isolate the unit under test:
      """
      checklist = gimme(Checklist)
      recipient = gimme(Recipient)

      DeliversMessages.new(checklist).deliver("WHY HELLO GOOD SIR", recipient)

      verify(recipient).add_to_mailbox(is_a(Mail))  #would force a Mail instance
      verify(recipient).add_to_mailbox(any(Mail))   #would also have allowed nil

      verify(checklist).check_off(any(String), recipient, anything) #anything matches anything

      """

  Scenario: using an argument captor to grab what was passed
    Then we can use gimme to isolate the unit under test:
      """
      checklist = gimme(Checklist)
      recipient = gimme(Recipient)

      DeliversMessages.new(checklist).deliver("WHY HELLO GOOD SIR", recipient)

      mail_captor = Gimme::Captor.new
      verify(recipient).add_to_mailbox(capture(mail_captor))
      mail_captor.value.contents.should == "WHY HELLO GOOD SIR"
      """

  Scenario: writing a custom starts_with matcher
    Then we can use gimme to isolate the unit under test:
      """
      checklist = gimme(Checklist)
      recipient = gimme(Recipient)

      DeliversMessages.new(checklist).deliver("WHY HELLO GOOD SIR", recipient)

      class StartsWith
        def initialize(expected)
          @expected = expected
        end

        def matches?(actual)
          actual.start_with?(@expected)
        end
      end
      def starts_with(s)
        StartsWith.new(s)
      end

      verify(checklist).check_off(starts_with("WHY"), anything, anything)
      """