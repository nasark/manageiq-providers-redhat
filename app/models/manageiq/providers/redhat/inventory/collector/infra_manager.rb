class ManageIQ::Providers::Redhat::Inventory::Collector::InfraManager < ManageIQ::Providers::Ovirt::Inventory::Collector::InfraManager
  def collected_inventory
    @collected_inventory ||= begin
                               inventory_collector = ManageIQ::Providers::Redhat::InfraManager::Inventory.new(:ems => manager)
                               inventory_collector.refresh
                             end
  end
end
