require 'spec_helper'

RSpec.describe Result::Result do
  describe '.[]' do
    before do
      allow(AsResult).to(receive(:call)).and_call_original
      AsResult[42]
    end

    it 'calls .call' do
      allow(AsResult).to(receive(:call)).and_call_original
      AsResult[42]
    end
  end
end
