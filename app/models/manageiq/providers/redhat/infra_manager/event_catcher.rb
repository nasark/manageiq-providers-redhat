class ManageIQ::Providers::Redhat::InfraManager::EventCatcher < ManageIQ::Providers::BaseManager::EventCatcher
  require_nested :Runner
  #might need to set event catcher settings name here
end
