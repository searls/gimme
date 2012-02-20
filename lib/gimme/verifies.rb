module Gimme

  class Verifies < BlankSlate
    attr_accessor :raises_no_method_error
    def initialize(double,times=1)
      @double = double
      @times = times
      @raises_no_method_error = true
    end

    def method_missing(sym, *args, &block)
      sym = MethodResolver.resolve_sent_method(@double,sym,args,@raises_no_method_error)

      #gosh, this loop sure looks familiar. just like another ugly loop I know. TODO.
      invoked = 0
      if @double.invocations[sym]
         @double.invocations[sym].each do |invoke_args,count|
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
        call_history = []
        @double.invocations.each { |sym, hist| call_history << "\t#{sym}"
          hist.each { |args,count| call_history << "\t\twas called #{count} times with the following arguments #{args}" }
        }
        history = call_history.join("\n")
        raise Errors::VerificationFailedError.new("expected #{sym} to have been called with #{args}\nWhat has happened\n#{history}")
      end
    end
  end

  def verify(double,times=1)
    Gimme::Verifies.new(double,times)
  end

  def verify!(double,times=1)
    verify = verify(double,times)
    verify.raises_no_method_error = false
    verify
  end
end
