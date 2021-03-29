require 'spec_helper'

RSpec.describe 'SuperSimple::Chainable' do
  class StrCommand < SuperSimple::Result
    def call
      @content = @content.to_s
    end
  end

  class UpperCommand < SuperSimple::Result
    def call
      @content = @content.upcase
    end
  end

  shared_examples 'Chain Result successfully' do
    it 'succeed' do
      expect(subject).to(be_success)
    end

    it 'returns last success command' do
      expect(subject).to(be_a(UpperCommand))
    end

    it 'results HELLO string' do
      expect(subject.result).to(eq('HELLO'))
    end
  end

  shared_examples 'Chain Result faild' do
    it 'faild' do
      expect(subject).to(be_failure)
    end

    it 'returns first faild command' do
      expect(subject).to(be_a(SuperSimple::Failure))
    end

    it 'results hello string' do
      expect(subject.result).to(eq('hello'))
    end

    it 'returns errors' do
      expect(subject.errors.details).to(eq({ result: Set[:failure] }))
    end
  end

  describe '#then' do
    context 'Success suit' do
      subject do
        SuperSimple::Params[:hello]
          .then(StrCommand)
          .then(UpperCommand)
      end

      it_should_behave_like 'Chain Result successfully'
    end

    context ' suit one failure in the middle' do
      subject do
        SuperSimple::Params[:hello]
          .then(StrCommand)
          .then(SuperSimple::Failure)
          .then(UpperCommand)
          .then(SuperSimple::Failure)
          .then(SuperSimple::Success)
      end

      it_should_behave_like 'Chain Result faild'
    end
  end

  describe '#|' do
    context 'Success suit' do
      subject { SuperSimple::Params[:hello] | SuperSimple::Success | StrCommand | UpperCommand }

      it_should_behave_like 'Chain Result successfully'
    end

    context ' suit one failure in the middle' do
      subject do
        SuperSimple::Params[:hello]
          .|(StrCommand)
          .|(SuperSimple::Failure)
          .|(UpperCommand)
          .|(SuperSimple::Failure)
          .|(SuperSimple::Success)
      end

      it_should_behave_like 'Chain Result faild'
    end
  end
end
