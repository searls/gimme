module Gimme
  module RSpecAdapter
    def setup_mocks_for_rspec
    end

    def verify_mocks_for_rspec
    end

    def teardown_mocks_for_rspec
      Gimme.reset
    end
  end
end