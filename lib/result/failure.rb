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

    def with_errors(errors)
      @errors = errors
      self
    end
  end
end
