require 'spec_helper'

RSpec.describe EurekaBot::Tg::Resolver do

  let(:message) { build(:telegram_message) }
  let(:resolver) { EurekaBot::Tg::Resolver.new(message: {'message' => message}) }
  it do
    expect(resolver.resolve).to include(:controller, :action)
  end

  context 'commands' do
    context 'no params' do
      let(:message) { build(:telegram_message, text: '/start') }
      it do
        expect(resolver.resolve).to eq(controller: 'commands', action: :start, params: {raw: [], version: 'v1'})
      end
    end
    context 'with params' do
      let(:message) { build(:telegram_message, text: '/start op1 op2 /op3') }
      it do
        expect(resolver.resolve).to eq(controller: 'commands', action: :start, params: {raw: ['op1', 'op2', '/op3'], version: 'v1'})
      end
    end
  end

end
