class EurekaBot::Tg::Controller::Response < EurekaBot::Controller::Response

  set_callback :add, :after, :consume

  def consume
    while element = @data.shift
      EurekaBot::Job::Output.perform_later(
          self.class.sender_class.to_s,
          element
      )
    end
  end

  def self.sender_class
    @@sender_class ||= EurekaBot::Tg::Sender
  end

end
