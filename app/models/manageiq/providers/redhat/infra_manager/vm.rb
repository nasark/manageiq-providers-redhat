ManageIQ::Providers::Ovirt::InfraManager::Vm.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager::Vm < ManageIQ::Providers::Ovirt::InfraManager::Vm
  include RemoteConsole
  include ManageIQ::Providers::Redhat::InfraManager::VmOrTemplateShared

  supports :migrate do
    if blank? || orphaned? || archived?
      "Migrate operation in not supported."
    else
      ext_management_system.unsupported_reason(:migrate)
    end
  end

  supports :reconfigure_disks do
    if storage.blank?
      _('storage is missing')
    elsif ext_management_system.blank?
      _('The virtual machine is not associated with a provider')
    else
      ext_management_system.unsupported_reason(:reconfigure_disks)
    end
  end

  supports_not :reset
  supports :publish do
    if blank? || orphaned? || archived?
      _('Publish operation in not supported')
    elsif ext_management_system.blank?
      _('The virtual machine is not associated with a provider')
    elsif power_state != "off"
      _('The virtual machine must be down')
    else
      ext_management_system.unsupported_reason(:publish)
    end
  end

  supports :reconfigure_network_adapters

  supports :reconfigure_disksize do
    'Cannot resize disks of a VM with snapshots' if snapshots.count > 1
  end

  def provider_object(connection = nil)
    ManageIQ::Providers::Redhat::InfraManager::OvirtServices::V4.new(:ems => ext_management_system).get_vm_proxy(self, connection)
  end

  def self.display_name(number = 1)
    n_('Virtual Machine (Red Hat)', 'Virtual Machines (Red Hat)', number)
  end
end
