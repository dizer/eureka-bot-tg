require 'spec_helper'

RSpec.describe EurekaBot::Tg::Client do
  let(:client) {EurekaBot::Tg::Client.new(token: tg_token)}

  context '#getMe' do
    it do
      stub_request(:get, 'https://api.telegram.org/botMYTOKEN/getMe').
          with(headers: {'Content-Type' => 'application/JSON'}).
          to_return(status: 200, body: {ok: true, result: {id: 123, first_name: 'Bot Name', username: 'MyBot'}}.to_json)
      expect(client.make_request('getMe')).to eq({id: 123, first_name: 'Bot Name', username: 'MyBot'}.as_json)
    end
  end

  context '#getUpdates' do
    let(:update) {build(:telegram_update)}
    it do
      stub_request(:get, 'https://api.telegram.org/botMYTOKEN/getUpdates').
          to_return(
              status: 200,
              body:   {
                          ok:     true,
                          result: [update]
                      }.to_json
          )
      expect(client.make_request('getUpdates')).to eq([update])
    end
  end

  context '#sendMessage'do
    it do
      stub_request(:post, 'https://api.telegram.org/botMYTOKEN/sendMessage').
          with(body:    {chat_id: chat_id, text: 'hello'}.to_json,
               headers: {'Content-Type' => 'application/JSON'}).
          to_return(status: 200, body: {ok: true, result: {message_id: 1, text: 'hello'}}.to_json)

      expect(
          client.make_request('sendMessage', method: :post, payload: {chat_id: chat_id, text: 'hello'}.to_json)
      ).to include('message_id', 'text')
    end
  end

  context '#get_file_url' do
    let(:file_id) { 'AgADBQADAagxG9uMoVfoZ4h_LRhUliwLzDIABA03Ej5dh9tzJLoAAgI' }
    it do
      stub_request(:get, 'https://api.telegram.org/botMYTOKEN/getFile').
          with(body: {file_id: file_id}.to_json).
          to_return(status: 200, body:  {ok: true, result: {file_path: 'files/image.jpg'}}.to_json)

      expect(client.get_file_url('AgADBQADAagxG9uMoVfoZ4h_LRhUliwLzDIABA03Ej5dh9tzJLoAAgI')).to eq('https://api.telegram.org/file/botMYTOKEN/files/image.jpg')
    end
  end

end
