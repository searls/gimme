module Gimme
  class FindsStubbings
    def initialize(stubbings)
      @stubbings = stubbings || {}
    end

    def count(method, args)
      stubbings_for(method, args).size
    end

    def find(method, args)
      stubbings_for(method, args).last
    end

  private
    def stubbings_for(method, args)
      return [] unless @stubbings[method]
      @stubbings[method].find { |(stub_args, blk)| ComparesArgs.new(args, stub_args).match? } || []
    end
  end

  class InvokesSatisfiedStubbing
    def initialize(stubbings)
      @finder = FindsStubbings.new(stubbings)
    end

    def invoke(method, args)
      if blk = @finder.find(method, args)
        blk.call
      elsif method.to_s[-1,1] == '?'
        false
      else
        nil
      end
    end
  end
end
