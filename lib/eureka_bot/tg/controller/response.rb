class EurekaBot::Tg::Controller::Response < EurekaBot::Controller::Response

  set_callback :add, :after, :consume

  def consume
    while element = @data.shift
      client = controller.tg_client
      client.api.send(element[:method], *Array.wrap(element[:params]))
    end
  end

end
