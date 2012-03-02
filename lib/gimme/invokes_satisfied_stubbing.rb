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
      match = nil

      @stubbings[method].each do |stub_args,stub_block|
        matching = args.size == stub_args.size
        args.each_index do |i|
          unless args[i] == stub_args[i] || (stub_args[i].respond_to?(:matches?) && stub_args[i].matches?(args[i]))
            matching = false
            break
          end
        end
        match = stub_block if matching
      end

      match
    end

  end
end