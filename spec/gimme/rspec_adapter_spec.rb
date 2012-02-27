require 'spec_helper'

module Gimme::RSpecAdapter
  describe "subject" do
    Then { setup_mocks_for_rspec }
    Then { verify_mocks_for_rspec }

    describe "#teardown_mocks_for_rspec" do
      # Given { spy_on(Gimme).reset }
      When { RSpecAdapter.teardown_mocks_for_rspec }
      # Then { verify(Gimme).reset }
    end
  end
end
