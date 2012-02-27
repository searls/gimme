require 'spec_helper'

module Gimme
  describe Errors do
    specify { Errors::VerificationFailedError.kind_of? StandardError }
  end
end