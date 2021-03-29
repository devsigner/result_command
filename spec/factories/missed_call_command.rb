class MissedCallCommand
  prepend SuperSimple::Command

  def initialize(input)
    @input = input
  end
end
