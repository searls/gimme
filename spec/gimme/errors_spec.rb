require 'spec_helper'

describe Gimme::Errors do
  specify { Gimme::Errors::VerificationFailedError.kind_of? StandardError }
end