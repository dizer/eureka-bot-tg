require 'spec_helper'

RSpec.describe EurekaBot::Tg::Controller do

  context 'response' do
    let(:controller_class) do
      Class.new(EurekaBot::Tg::Controller) do
        def some_action
          answer(
              method: 'sendMessage',
              params: {
                  text: 'sample message'
              }
          )
        end
      end
    end
    let(:controller) { controller_class.new(message: build(:telegram_message)) }

    it do
      expect(controller.response).to be_a_kind_of(EurekaBot::Tg::Controller::Response)
    end

    context 'message sending' do
      let(:controller) { controller_class.new(message: build(:telegram_message)) }

      it do
        stub_request(:post, "https://api.telegram.org/botExample/sendMessage")
            .to_return(body: {result: 'ok'}.to_json)
        controller.some_action
        expect(WebMock).to have_requested(:post, 'https://api.telegram.org/botExample/sendMessage')
      end
    end
  end

end
