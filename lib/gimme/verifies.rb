module Gimme

  class Verifies < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(double,times=1)
      @double = double
      @times = times.respond_to?(:count) ? times.count : times
      @raises_no_method_error = true
    end

    def __gimme__cls
      @double.cls
    end

    def method_missing(sym, *args, &block)
      sym = ResolvesMethods.new(__gimme__cls,sym,args).resolve(@raises_no_method_error)

      if @times != invocation_count(sym, args)
        raise Errors::VerificationFailedError.new(message_for(sym, args))
      end
    end

    private

    def invocation_count(sym, args)
      invocations = Gimme.invocations.get(@double, sym)
      return 0 unless invocations
      invocations.inject(0) do |memo, (invoke_args, count)|
        ComparesArgs.new(invoke_args, args).match? ? memo + count : memo
      end
    end

    def message_for(sym, args)
      msg = "expected #{__gimme__cls || @double}##{sym} to have been called with arguments #{args}"
      if !Gimme.invocations.get(@double, sym) || Gimme.invocations.get(@double, sym).empty?
        msg << "\n  but was never called"
      else
        msg = Gimme.invocations.get(@double, sym).inject msg do |memo, actual|
          memo + "\n  was actually called #{actual[1]} times with arguments #{actual[0]}"
        end
      end
    end
  end

end
