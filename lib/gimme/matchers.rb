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
    
    class Numeric < Matcher
      def matches?(arg)
        arg.kind_of?(Fixnum) || arg.kind_of?(Numeric) || arg.kind_of?(Float)
      end
    end
    
    class IsA < Matcher
      def initialize(cls)
        @cls = cls
      end
      
      def matches?(arg)
        arg.kind_of?(@cls)
      end
    end
    
    class Any < IsA
      def matches?(arg)
        arg == nil || arg.kind_of?(@cls)
      end
    end    
  end

  def anything
    Gimme::Matchers::Anything.new
  end

  def numeric
    Gimme::Matchers::Numeric.new
  end

  def is_a(cls)
    Gimme::Matchers::IsA.new(cls)
  end

  def any(cls)
    Gimme::Matchers::Any.new(cls)
  end

end