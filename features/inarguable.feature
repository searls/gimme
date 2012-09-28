Feature:

  Sometimes we don't care how a method is called, we always want
  a method to reply with a stubbing, regardless of the arguments passed.
  For that, you can use the `inarguable` configuration

  give(car).speed { 99 }.inarguably

  Will always return 99, whether you call `car.speed`, `car.speed(1)`, or `car.speed(1,2,3,4,5)`

  For verification, you can chain the verify call with inarguably before
  you call through to the method you wish to verify. In the example below,
  one might:

  verify(driver).inarguably.taze!

  Which will be satisfied so long as `taze!` is invoked, regardless of arguments

  Scenario: inarguable stubbing
    Given we have this production code:
    """
    class Cop
      def initialize(car = Car.new)
        @car = car
      end

      def pull_over?
        @car.speed(:radar) > 90
      end
    end

    class Car
      def speed(method = :eyesight)
      end
    end
    """
    Then this RSpec will pass:
    """
    describe Cop do
      Given!(:car) { gimme_next(Car) }

      describe "#pull_over?" do
        context "is speeding" do
          Given { give(car).inarguably.speed { 99 } }
          When(:result) { subject.pull_over? }
          Then { result.should be_true }
        end
      end
    end
    """

  Scenario: inarguable verification
    Given we have this production code:
    """
    class Cop
      def initialize(driver = Driver.new)
        @driver = driver
      end

      def arrest
        @driver.taze!(:high)
      end
    end

    class Driver
      def taze!(power = :dont_taze_me_bro)
      end
    end
    """
    Then this RSpec will pass:
    """
    describe Cop do
      Given!(:driver) { gimme_next(Driver) }

      describe "#arrest" do
        context "is speeding" do
          When(:result) { subject.arrest }
          Then { verify(driver).inarguably.taze! }
        end
      end
    end
    """





