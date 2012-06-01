module Gimme
  class ComparesArgs
    def match?(left, right)
      matching = left.size == right.size
      left.each_index do |i|
        unless left[i] == right[i] || (right[i].respond_to?(:matches?) && right[i].matches?(left[i]))
          matching = false
          break
        end
      end
      matching
    end
  end
end