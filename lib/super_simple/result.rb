# frozen_string_literal: true

module SuperSimple
  class Result
    def self.inherited(subclass)
      subclass.prepend Command
    end

    def initialize(content)
      @content = content
    end

    def call
      @content
    end
  end
end
