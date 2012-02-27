module Gimme
  @@stuff_to_do_on_reset = []

  def self.on_reset (&blk)
    @@stuff_to_do_on_reset << blk
  end

  def self.reset
    @@stuff_to_do_on_reset.delete_if do |stuff|
      stuff.call
      true
    end
  end
end