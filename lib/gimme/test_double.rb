module Gimme
  class BlankSlate
    warning_level = $VERBOSE
    $VERBOSE = nil
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
    $VERBOSE = warning_level
  end

  class TestDouble < BlankSlate
    attr_accessor :cls
    attr_accessor :stubbings
    attr_reader :invocations

    def initialize(cls=nil)
      @cls = cls
      @stubbings = {}
      @invocations = {}
    end

    def method_missing(sym, *args, &block)
      sym = ResolvesMethods.new(self.cls,sym,args).resolve(false)

      @invocations[sym] ||= {}
      @stubbings[sym] ||= {}

      @invocations[sym][args] = 1 + (@invocations[sym][args]||0)

      matching_stub_block = nil
      @stubbings[sym].each do |stub_args,stub_block|
        matching = args.size == stub_args.size
        args.each_index do |i|
          unless args[i] == stub_args[i] || (stub_args[i].respond_to?(:matches?) && stub_args[i].matches?(args[i]))
            matching = false
            break
          end
        end
        matching_stub_block = stub_block if matching
      end

      if matching_stub_block
        matching_stub_block.call
      elsif sym.to_s[-1,1] == '?'
        false
      else
        nil
      end
    end
  end

  def gimme(cls=nil)
    Gimme::TestDouble.new(cls)
  end

  def gimme_next(cls)
    double = Gimme::TestDouble.new(cls)
    meta_class = class << cls; self; end
    real_new = cls.method(:new)
    meta_class.send(:define_method,:new) do |*args|
      double.send(:initialize,*args)
      meta_class.send(:define_method,:new,real_new) #restore :new on the class
      double
    end
    double
  end

end
