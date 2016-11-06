require 'spec_helper'

RSpec.describe EurekaBot::Tg::Webhook do

  context '#check_token' do
    let(:wh) do
      EurekaBot::Tg::Webhook.new(params: {token: 'ABC'}, resolver_class: OpenStruct)
    end

    it do
      expect(wh.check_token('ABC')).to eq(true)
      expect(wh.check_token('AbC')).to eq(false)
      expect(wh.check_token('DEF')).to eq(false)
      expect(wh.check_token('')).to eq(false)
      expect(wh.check_token(nil)).to eq(false)
    end
  end

end
