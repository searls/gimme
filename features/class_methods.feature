Feature: class methods

  Scenario: stubbing and verifying behavior
    Given we have this existing code:
      """
      class Cat
        def interact(type)
        end
      end

      class CatRepository
        def self.find(cat_id)
        end
      end
      """
    When we want to write some tests to help us write this method:
      """
      class ScratchesCat
        def scratch(cat_id)
          CatRepository.find(cat_id).interact(:scratch)
        end
      end
      """
    Then we can use gimme to isolate the unit under test:
      """
      cat = gimme(Cat)
      give(CatRepository).find(12) { cat }

      ScratchesCat.new.scratch(12)

      verify(CatRepository).find(12)
      verify(cat).interact(:scratch)

      # to clear any class method stubbings, do this:
      Gimme.reset  # in RSpec, Gimme::RSpecAdapter can do this on teardown for you.
      """
