module Gimme

  class Verifies < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(double,times=1)
      @double = double
      @times = times
      @raises_no_method_error = true
    end

    def method_missing(sym, *args, &block)
      sym = ResolvesMethods.new(@double.cls,sym,args).resolve(@raises_no_method_error)

      #gosh, this loop sure looks familiar. just like another ugly loop I know. TODO.
      invoked = 0
      if Gimme.invocations.get(@double, sym)
         Gimme.invocations.get(@double, sym).each do |invoke_args,count|
           matching = args.size == invoke_args.size
           invoke_args.each_index do |i|
             unless invoke_args[i] == args[i]  || (args[i].respond_to?(:matches?) && args[i].matches?(invoke_args[i]))
               matching = false
               break
             end
           end
           invoked += count if matching
         end
      end

      if invoked != @times
        msg = "expected #{@double.cls.to_s}##{sym} to have been called with arguments #{args}"
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
