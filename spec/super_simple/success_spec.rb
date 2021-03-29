require 'spec_helper'

RSpec.describe SuperSimple::Success do
  subject { described_class[42] }

  describe '#success?' do
    it 'is true' do
      expect(subject.success?).to(be_truthy)
    end
  end

  describe '#failure?' do
    it 'is false' do
      expect(subject.failure?).to(be_falsy)
    end
  end

  describe '#result' do
    it 'returns the content' do
      expect(subject.result).to(eq(42))
    end
  end
end
