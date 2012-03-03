module Gimme

  class VerifiesClassMethods < Verifies
    def __gimme__cls
      (class << @double; self; end)
    end
  end
end
