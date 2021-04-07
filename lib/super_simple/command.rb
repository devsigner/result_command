# frozen_string_literal: true

module SuperSimple
  # Command
  #
  # wrap result after running call method
  #
  #   cmd = MyCommand.call(args)
  #
  #   cmd.success? # => true | false
  #   cmd.failure? # => true | false
  #
  # Errors
  #
  # on failure `errors` return Errors instance
  #
  # Callback
  #   MyCommand.call(args) do |cmd|
  #     cmd.on_success do |result|
  #       # do something
  #     end
  #
  #     cmd.on_failure do |errors|
  #       # or do something else
  #     end
  #   end
  #
  module Command
    class NotImplementedError < ::StandardError; end

    attr_reader :result

    module ClassMethods
      def call(*args)
        new(*args).call
      end

      def [](*args)
        new(*args).call
      end
    end

    def self.prepended(base)
      base.extend ClassMethods
      base.include Chainable
    end

    # call
    #
    # wrap implemented call method and
    # set @result with with the return of the implemented call
    #
    # @return self
    def call
      raise(NotImplementedError) unless defined?(super)

      @called = true
      @result = super

      yield(self) if block_given?

      self
    end

    # success?
    #
    # @return Boolean
    def success?
      called? && !failure?
    end
    alias successful? success?

    # failure?
    #
    # @return Boolean
    def failure?
      called? && errors.any?
    end

    # errors
    #
    # @return Errors instance
    def errors
      return super if defined?(super)

      @errors ||= Errors.new(self)
    end

    # on_success callback
    #
    # @yield result
    #
    # @return self
    def on_success
      call unless called?
      return self unless success?

      yield(result) if block_given?

      self
    end

    # on_failure callback
    #
    # @yield errors
    #
    # @return self
    def on_failure
      call unless called?
      return self unless failure?

      yield(errors) if block_given?

      self
    end

    private

    def called?
      @called ||= false
    end
  end
end
