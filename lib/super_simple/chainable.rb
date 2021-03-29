module SuperSimple
  module Chainable
    def then(other)
      call unless called?

      if success?
        other.call(result)
      else
        self
      end
    end
    alias | then
  end
end
