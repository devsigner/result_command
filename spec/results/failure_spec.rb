require 'spec_helper'

RSpec.describe Result::Failure do
  subject { described_class[22] }

  describe '#success?' do
    it 'is false' do
      expect(subject.success?).to(be_falsy)
    end
  end

  describe '#failure?' do
    it 'is true' do
      expect(subject.failure?).to(be_truthy)
    end
  end

  describe '#result' do
    it 'returns the content' do
      expect(subject.result).to(eq(22))
    end
  end

  describe '#errors' do
    it ' returns errors' do
      expect(subject.errors.details).to(eq({result: Set[:failure]}))
    end

    it' returns Errors' do
      expect(subject.errors).to(be_a(Result::Errors))
    end

    context 'with CustomErrors' do
      subject(:subject_error) { described_class[22] }

      before do
        described_class.prepend(CustomErrors::Instances)
      end

      it 'returns the content' do
        expect(subject_error.result).to(eq(22))
      end

      it 'returns CustomErrors' do
        expect(subject_error.errors).to(be_a(CustomErrors))
      end

      it ' returns errors details' do
        expect(subject.errors.details).to(eq({result: Set[:failure]}))
      end
    end
  end
end
