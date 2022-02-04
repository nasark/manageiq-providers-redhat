class ManageIQ::Providers::Redhat::InfraManager::Refresher < ManageIQ::Providers::Ovirt::InfraManager::Refresher
  def collect_inventory_for_targets(ems, targets)
    inventory = inventory_from_redhat(ems)
    raise "Invalid RHEV server ip address." if inventory.api.nil?

    # TODO: before iterating over targets it would be good to check whether ExtMgmntSystem is part of it
    # TODO optimize not to fetch the same objects like clusters for multiple targets

    targets_with_data = targets.collect do |target|
      _log.info "Filtering inventory for #{target.class} [#{target.name}] id: [#{target.id}]..."

      ems_api_version = inventory.service.version_string.match(/([\d][\.\d]+)/)
      data = ManageIQ::Providers::Redhat::Inventory.build(ems, target)

      # TODO: remove when graph refresh supports ems updates
      ems.api_version = ems_api_version
      ems.save

      empty_hash_when_target_not_found!(target, data) if targeted_refresh?(target)

      data.instance_variable_set(:@ems_api_version, :api_version => ems_api_version)

      _log.info "Filtering inventory...Complete"
      [target, data]
    end

    ems.ensure_managers

    targets_with_data
  end

  def inventory_from_redhat(ems)
    @ems = ems
    ManageIQ::Providers::Redhat::InfraManager::Inventory.new(:ems => ems)
  end

  private

  def empty_hash_when_target_not_found!(target, data)
    empty_the_hash!(data) if corresponding_hashes_empty?(target, data)
  end

  def targeted_refresh?(target)
    target.kind_of?(VmOrTemplate) || target.kind_of?(Host)
  end

  def empty_the_hash!(data)
    data.each_key { |k| data[k] = nil }
  end

  def corresponding_hashes_empty?(target, data)
    case target
    when VmOrTemplate
      return data[:template].blank? if target.template?
      data[:vm].blank?
    when Host
      data[:host].blank?
    else
      false
    end
  end
end
