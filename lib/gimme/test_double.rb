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

    def initialize(cls_or_name=nil)
      @name = cls_or_name
      @cls = cls_or_name if cls_or_name.kind_of?(Class)
      @gimme_id = (@@gimme_count += 1)
    end

    def method_missing(method, *args, &block)
      method = ResolvesMethods.new(self.cls, method, args).resolve(false)
      Gimme.invocations.increment(self, method, args)
      InvokesSatisfiedStubbing.new(self).invoke(method, args)
    end

    def inspect(*args, &blk)
      method_missing(:inspect, *args, &blk) || "<#Gimme:#{@gimme_id} #{@name}>"
    end

    def to_s(*args, &blk)
      if stubbed?(:to_s, *args, &blk)
        method_missing(:to_s, *args, &blk)
      else
        inspect
      end
    end

    def hash(*args, &blk)
      if stubbed?(:hash, *args, &blk)
        method_missing(:hash, *args, &blk)
      else
        __id__
      end
    end

    def eql?(other, *args, &blk)
      if stubbed?(:eql?, other, *args, &blk)
        method_missing(:eql?, other, *args, &blk)
      else
        __id__ == other.__id__
      end
    end

    def ==(other, *args, &blk)
      if stubbed?(:==, other, *args, &blk)
        method_missing(:==, other, *args, &blk)
      else
        eql?(other)
      end
    end

  private
    def stubbed?(method, *args, &blk)
      FindsStubbings.new(self).count(method, args) > 0
    end
  end

end
