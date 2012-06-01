module Gimme
  class InvokesSatisfiedStubbing
    def initialize(stubbings)
      @stubbings = stubbings || {}
    end

    def invoke(method, args)
      if @stubbings[method] && blk = find_matching_stubbing(method, args)
        blk.call
      elsif method.to_s[-1,1] == '?'
        false
      else
        nil
      end
    end

    private

    def find_matching_stubbing(method, args)
      if matching_stubbing = @stubbings[method].find { |(stub_args, blk)| ComparesArgs.new(args, stub_args).match? }
        matching_stubbing.last
      end
    end
  end
end
