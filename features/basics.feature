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
    Given we have this existing code:
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
          @slicer = slicer
          @stove = stove
        end
      end

      """

    When we want to write some tests to help us write this method:
      """
      class Chef
        def cook
          slices = @slicer.slice("tomato")
          @stove.simmer(slices)
        end
      end
      """

    Then we can use gimme to isolate the unit under test:
      """
      slicer = gimme(Apprentice)
      stove = gimme(Stove)
      give(slicer).slice("tomato") { "some slices" }

      Chef.new(slicer, stove).cook

      verify(stove).simmer("some slices")
      """