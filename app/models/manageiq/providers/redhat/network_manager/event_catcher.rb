class ManageIQ::Providers::Redhat::NetworkManager::EventCatcher < ::MiqEventCatcher
  require_nested :Runner

  def self.all_valid_ems_in_zone
    []
  end

  def self.settings_name
    :event_catcher_redhat_network
  end
end
