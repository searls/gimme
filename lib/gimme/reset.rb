module Gimme
  @@stuff_to_do_on_reset = []
  @@stuff_to_do_on_every_reset = []

  def self.on_reset (situation = :once, &blk)
    if situation == :once
      @@stuff_to_do_on_reset << blk
    else
      @@stuff_to_do_on_every_reset << blk
    end
  end

  def self.reset
    @@stuff_to_do_on_reset.delete_if { |stuff| stuff.call || true }
    @@stuff_to_do_on_every_reset.each { |stuff| stuff.call }
  end
end