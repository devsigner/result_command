# frozen_string_literal: true

module Result
  class Failure < Result
    def failure?
      true
    end

    def call
      errors.add(:result, :failure)
      super
    end
  end
end
