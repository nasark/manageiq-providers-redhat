ManageIQ::Providers::Ovirt::InfraManager::Datacenter.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager::Datacenter < ManageIQ::Providers::Ovirt::InfraManager::Datacenter
  def external_distributed_virtual_switches
    distributed_virtual_switches.select do |s|
      s.kind_of?(ManageIQ::Providers::Redhat::InfraManager::ExternalDistributedVirtualSwitch)
    end
  end
end
