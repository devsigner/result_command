class MissedCallCommand
  prepend Result::Command

  def initialize(input)
    @input = input
  end
end
