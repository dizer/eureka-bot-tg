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

  context 'sync message sending' do
    let(:controller_class) do
      Class.new(EurekaBot::Tg::Controller) do
        attr_accessor :rspec_answer
        def some_action
          @rspec_answer = answer(
              method: 'sendMessage',
              params: {
                  text: 'sample message'
              },
              sync: true
          )
        end
      end
    end
    let(:controller) { controller_class.new(message: {message: build(:telegram_message, chat: {id: chat_id})}.as_json) }
    let(:stub_answer) { {message_id: 1, text: 'hello'} }
    around do |block|
      adapter = EurekaBot::Job.queue_adapter
      begin
        EurekaBot::Job.queue_adapter = :async
        block.call
      ensure
        EurekaBot::Job.queue_adapter = adapter
      end
    end
    before do
      EurekaBot::Tg.client = EurekaBot::Tg::Client.new(token: tg_token)
      stub_request(:post, 'https://api.telegram.org/botMYTOKEN/sendMessage').
          with(body:    {chat_id: chat_id, text: 'sample message'}.to_json,
               headers: {'Content-Type' => 'application/JSON'}).
          to_return(status: 200, body: {ok: true, result: stub_answer}.to_json)
    end
    it do
      controller.execute(:some_action)
      expect(WebMock).to have_requested(:post, "https://api.telegram.org/bot#{tg_token}/sendMessage")
      expect(controller.rspec_answer).to eq(stub_answer.as_json)
    end
  end

end
