module Gimme
  class FindsStubbings
    def initialize(stubbed_thing)
      @stubbings = Gimme.stubbings.get(stubbed_thing) || {}
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
end