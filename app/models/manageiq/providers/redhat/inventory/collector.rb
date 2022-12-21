class ManageIQ::Providers::Redhat::Inventory::Collector < ManageIQ::Providers::Ovirt::Inventory::Collector
  # TODO: review the changes here and find common parts with ManageIQ::Providers::Redhat::InfraManager::Inventory::Strategies::V4
  require_nested :InfraManager
  require_nested :NetworkManager
  require_nested :TargetCollection
end
