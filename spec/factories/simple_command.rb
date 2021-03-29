class SimpleCommand
  prepend SuperSimple::Command

  def initialize(input)
    @input = input
  end

  def call
    @input * 2
  end
end
