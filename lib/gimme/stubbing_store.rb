module Gimme

  class StubbingStore < Store

    def invoke(double, method, args)
      if stubbing = get(double, method, args)
        stubbing.call
      end
    end

  end
  
  def self.stubbings
    @@stubbings ||= StubbingStore.new
    Gimme.on_reset do
      @@stubbings.clear
    end
  end
  
end