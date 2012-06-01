require 'gimme/test_double'
require 'gimme/resolves_methods'
require 'gimme/errors'
require 'gimme/gives'
require 'gimme/gives_class_methods'
require 'gimme/ensures_class_method_restoration'
require 'gimme/verifies'
require 'gimme/spies_on_class_methods'
require 'gimme/verifies_class_methods'
require 'gimme/matchers'
require 'gimme/captor'
require 'gimme/invokes_satisfied_stubbing'
require 'gimme/reset'
require 'gimme/dsl'
require 'gimme/store'
require 'gimme/stubbing_store'
require 'gimme/invocation_store'
require 'gimme/method_store'
require 'gimme/compares_args'

require 'gimme/rspec_adapter'

include Gimme::Matchers
include Gimme::DSL