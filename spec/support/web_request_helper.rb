module WebRequestHelper
  def with_web_request(&block)
    previous_allowed = WebMock.net_connect_allowed?
    begin
      WebMock.allow_net_connect!
      VCR.turned_off(&block)
    ensure
      WebMock.disable_net_connect! unless previous_allowed
    end
  end
end
