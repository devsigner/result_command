# frozen_string_literal: true

class CustomErrors < SuperSimple::Errors
  module Instances
    def errors
      @errors ||= CustomErrors.new(self)
    end
  end
end
