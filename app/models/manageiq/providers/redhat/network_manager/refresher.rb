module ManageIQ::Providers
  class Redhat::NetworkManager::Refresher < Ovirt::NetworkManager::Refresher
    def collect_inventory_for_targets(ems, targets)
      targets_with_data = targets.collect do |target|
        target_name = target.try(:name) || target.try(:event_type)

        _log.info("Filtering inventory for #{target.class} [#{target_name}] id: [#{target.id}]...")

        inventory = ManageIQ::Providers::Redhat::Inventory.build(ems, target)

        _log.info("Filtering inventory...Complete")
        [target, inventory]
      end

      targets_with_data
    end
  end
end
