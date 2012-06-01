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
      compares_args = ComparesArgs.new
      if matching_stubbing = @stubbings[method].find { |(stub_args, blk)| compares_args.match?(args, stub_args) }
        matching_stubbing.last
      end
    end
  end
end
