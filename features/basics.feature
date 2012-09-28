Feature: basic usage

  Gimme is designed for easy & reliable isolated unit testing of Ruby classes.

  This example illustrates:
    <ul>
      <li>How to create a test double for a known class</li>
      <li>Injecting that double into the subject code we're specifying</li>
      <li>Stubbing a method on a test double to return a particular result</li>
      <li>Verify that a method on a test double was called with a particular argument</li>
    </ul>

  So say we've got a Chef who's job is to take the work product of his Apprentice
    and simmer it on the Stove. Here's how we might use gimme to write an isolation test
    of the Chef's job without actually calling through to a real Apprentice or a real Stove.

  Scenario:
    Given we have this production code:
    """
      class Apprentice
        def slice(thing)
          1000000.times.map do
            Slice.new(thing)
          end
        end
      end

      class Stove
        def simmer(stuff)
        end
      end

      class Slice
        def initialize(of)
        end
      end

      class Chef
        def initialize(slicer = Apprentice.new, stove = Stove.new)
          @slicer = slicer
          @stove = stove
        end

        def cook
          slices = @slicer.slice("tomato")
          @stove.simmer(slices)
        end
      end

      """
    Then this RSpec will pass:
      """
      describe Chef do
        describe "#cook" do
          Given!(:slicer) { gimme_next(Apprentice) }
          Given!(:stove) { gimme_next(Stove) }
          Given { give(slicer).slice("tomato") { "some slices" } }
          When { subject.cook }
          Then { verify(stove).simmer("some slices") }
        end
      end
      """

  Scenario: using rspec
    Given we have this production code:
      """
      class Spaceship
        def initialize(thruster = Thruster.new)
          @thruster = thruster
        end

        def take_off
          @thruster.fire
        end
      end

      class Thruster
        def fire
          raise "LOLTHRUSTER"
        end
      end
      """
    Then this RSpec will pass:
      """
      describe Spaceship do
        context "an injected double" do
          Given(:thruster) { gimme(Thruster) }
          subject { Spaceship.new(thruster) }
          When { subject.take_off }
          Then { verify(thruster).fire }
        end

        context "a gimme_next double" do
          Given!(:thruster) { gimme_next(Thruster) }
          When { subject.take_off }
          Then { verify(thruster).fire }
        end
      end
      """
