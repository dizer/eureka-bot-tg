require 'spec_helper'

RSpec.describe EurekaBot::Tg::Controller do

  context '#chat' do
    let(:message) { build(:telegram_message) }
    let(:controller) { EurekaBot::Tg::Controller.new(message: {message: message }.as_json)}
    it do
      expect(controller.chat_id).to eq(message.dig('chat', 'id'))
    end
  end

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
      let(:message) { build(:telegram_message, chat: {id: chat_id}) }
      let(:controller) { controller_class.new(message: {message: message }.as_json)}
      before do
        EurekaBot::Tg.client = EurekaBot::Tg::Client.new(token: tg_token)
        stub_request(:post, 'https://api.telegram.org/botMYTOKEN/sendMessage').
            with(body:    {chat_id: chat_id, text: 'sample message'}.to_json,
                 headers: {'Content-Type' => 'application/JSON'}).
            to_return(status: 200, body: {ok: true, result: {message_id: 1, text: 'hello'}}.to_json)
      end
      it do
        controller.some_action
        expect(WebMock).to have_requested(:post, "https://api.telegram.org/bot#{tg_token}/sendMessage")
      end
    end
  end

end
