class FilesBot::Resolver < EurekaBot::Tg::Resolver
  def controller_namespace
    FilesBot::Controller
  end
end