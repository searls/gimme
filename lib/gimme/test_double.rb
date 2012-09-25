module Gimme
  class BlankSlate
    warning_level = $VERBOSE
    $VERBOSE = nil
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    $VERBOSE = warning_level
  end

  class TestDouble < BlankSlate
    attr_accessor :cls

    @@gimme_count = 0
    Gimme.on_reset(:every) { @@gimme_count = 0 }

    def initialize(cls=nil)
      @cls = cls
      @gimme_id = (@@gimme_count += 1)
    end

    def method_missing(method, *args, &block)
      method = ResolvesMethods.new(self.cls, method, args).resolve(false)
      Gimme.invocations.increment(self, method, args)
      InvokesSatisfiedStubbing.new(Gimme.stubbings.get(self)).invoke(method, args)
    end

    def inspect(*args, &blk)
      method_missing(:inspect, *args, &blk) || "<#Gimme:#{@gimme_id} #{@cls}>"
    end

    def to_s(*args, &blk)
      method_missing(:to_s, *args, &blk) || inspect
    end

    def hash(*args, &blk)
      method_missing(:hash, *args, &blk) || __id__
    end

    def eql?(other, *args, &blk)
      method_missing(:eql?, other, *args, &blk) || __id__ == other.__id__
    end

    def ==(other, *args, &blk)
      method_missing(:==, other, *args, &blk) ||eql?(other)
    end
  end

end
