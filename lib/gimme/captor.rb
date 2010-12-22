module Gimme

  class Captor
    attr_accessor :value
  end

  class Capture < Matchers::Matcher
    def initialize(captor)
      @captor = captor
    end

    def matches?(arg)
      @captor.value = arg
      true
    end
  end

  def capture(captor)
    Capture.new(captor)
  end

end