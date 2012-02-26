module Gimme
  class InvokesSatisfiedStubbing
    def initialize(stubbings)
      @stubbings = stubbings
    end

    def invoke(method, args)
      matching_stub_block = nil
      @stubbings[method].each do |stub_args,stub_block|
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
      elsif method.to_s[-1,1] == '?'
        false
      else
        nil
      end
    end
  end
end