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

      invoked = 0
      if Gimme.invocations.get(@double, sym)
        compares_args = ComparesArgs.new
        Gimme.invocations.get(@double, sym).each do |invoke_args,count|
          invoked += count if compares_args.match?(invoke_args, args)
        end
      end

      if invoked != @times
        msg = "expected #{__gimme__cls.to_s}##{sym} to have been called with arguments #{args}"
        if !Gimme.invocations.get(@double, sym) || Gimme.invocations.get(@double, sym).empty?
          msg << "\n  but was never called"
        else
          msg = Gimme.invocations.get(@double, sym).inject msg do |memo, actual|
            memo + "\n  was actually called #{actual[1]} times with arguments #{actual[0]}"
          end
        end

        raise Errors::VerificationFailedError.new(msg)
      end
    end
  end

end
