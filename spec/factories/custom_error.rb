# frozen_string_literal: true

class CustomErrors < Result::Errors
  module Instances
    def errors
      @errors ||= CustomErrors.new(self)
    end
  end
end
