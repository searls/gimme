module Gimme

  class InvocationStore < Store

    def increment(double, method, args)
      set(double, method, args, get(double, method, args).to_i.succ)
    end
  end

  def self.invocations
    @@invocations ||= InvocationStore.new
    Gimme.on_reset do
      @@invocations.clear
    end
  end

end