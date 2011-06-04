module Gimme
  module Matchers
    class Matcher
      def matches?(arg)
        false
      end
    end

    class Anything < Matcher
      def matches?(arg)
        true
      end
    end
    def anything
      Gimme::Matchers::Anything.new
    end

   class IsA < Matcher
      def initialize(cls)
        @cls = cls
      end

      def matches?(arg)
        arg.kind_of?(@cls)
      end
    end
    def is_a(cls)
      Gimme::Matchers::IsA.new(cls)
    end

    class Any < IsA
      def matches?(arg)
        arg == nil || arg.kind_of?(@cls)
      end
    end
    def any(cls)
      Gimme::Matchers::Any.new(cls)
    end

    class Numeric < Matcher
      def matches?(arg)
        arg.kind_of?(Fixnum) || arg.kind_of?(Numeric) || arg.kind_of?(Float)
      end
    end
    def numeric
      Gimme::Matchers::Numeric.new
    end

    class Boolean < Matcher
      def matches?(arg)
        arg.kind_of?(TrueClass) || arg.kind_of?(FalseClass)
      end
    end
    def boolean
      Gimme::Matchers::Boolean.new
    end
  end
end
