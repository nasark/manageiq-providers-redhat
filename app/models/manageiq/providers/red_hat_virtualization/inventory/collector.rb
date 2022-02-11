class ManageIQ::Providers::Redhat::Inventory::Collector < ManageIQ::Providers::Ovirt::Inventory::Collector
  # TODO: review the changes here and find common parts with ManageIQ::Providers::Redhat::InfraManager::Inventory::Strategies::V4
  require_nested :InfraManager
  require_nested :NetworkManager
  require_nested :TargetCollection

  def collect_attached_disks(disks_owner)
    manager.with_provider_connection do |connection|
      ManageIQ::Providers::Redhat::InfraManager::Inventory::DisksHelper.collect_attached_disks(disks_owner, connection, preloaded_disks)
    end
  end

  def collect_disks_as_hash
    manager.with_provider_connection do |connection|
      ManageIQ::Providers::Redhat::InfraManager::Inventory::DisksHelper.collect_disks_as_hash(connection)
    end
  end
end
