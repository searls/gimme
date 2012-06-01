module Gimme
  class ComparesArgs

    def initialize(actual, expected)
      @actual = actual
      @expected = expected
    end

    def match?
      same_size? && same_args?
    end

    private

    def same_size?
      @actual.size == @expected.size
    end

    def same_args?
      @actual.each_index.all? do |i|
        @actual[i] == @expected[i] || matchers?(@expected[i], @actual[i])
      end
    end

    def matchers?(matcher, arg)
      matcher.respond_to?(:matches?) && matcher.matches?(arg)
    end

  end
end