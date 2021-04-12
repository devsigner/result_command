# frozen_string_literal: true

module Result
  class Errors
    def initialize(source)
      @source = source
      @errors = {}
    end

    def add(key, value, _opts = {})
      @errors[key] ||= Set.new
      @errors[key].add(value)
      self
    end

    def merge(other)
      other.details.each do |key, values|
        values.each { |value| add(key, value) }
      end
      self
    end

    def each
      details.each_key do |field|
        details[field].each { |message| yield field, message }
      end
    end

    def full_messages
      details.map { |attribute, message| full_message(attribute, message) }
    end

    def details
      @errors
    end

    def any?
      @errors.any?
    end

    def empty?
      @errors.empty?
    end

    private

    def full_message(attribute, message)
      return message if attribute == :base
      attr_name = attribute.to_s.tr('.', '_').capitalize
      "%s %s" % [attr_name, message]
    end
  end
end
