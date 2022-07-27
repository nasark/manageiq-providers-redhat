ManageIQ::Providers::Ovirt::InfraManager::Vm.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager::Vm < ManageIQ::Providers::Ovirt::InfraManager::Vm
  include_concern 'RemoteConsole'
  include_concern 'ManageIQ::Providers::Redhat::InfraManager::VmOrTemplateShared'

  supports :migrate do
    if blank? || orphaned? || archived?
      unsupported_reason_add(:migrate, "Migrate operation in not supported.")
    elsif !ext_management_system.supports?(:migrate)
      unsupported_reason_add(:migrate, 'RHV API version does not support migrate')
    end
  end

  supports :reconfigure_disks do
    if storage.blank?
      unsupported_reason_add(:reconfigure_disks, _('storage is missing'))
    elsif ext_management_system.blank?
      unsupported_reason_add(:reconfigure_disks, _('The virtual machine is not associated with a provider'))
    elsif !ext_management_system.supports?(:reconfigure_disks)
      unsupported_reason_add(:reconfigure_disks, _('The provider does not support reconfigure disks'))
    end
  end

  supports_not :reset
  supports :publish do
    if blank? || orphaned? || archived?
      unsupported_reason_add(:publish, _('Publish operation in not supported'))
    elsif ext_management_system.blank?
      unsupported_reason_add(:publish, _('The virtual machine is not associated with a provider'))
    elsif !ext_management_system.supports?(:publish)
      unsupported_reason_add(:publish, _('This feature is not supported by the api version of the provider'))
    elsif power_state != "off"
      unsupported_reason_add(:publish, _('The virtual machine must be down'))
    end
  end

  supports :reconfigure_network_adapters

  # supports :reconfigure_disksize
  supports :reconfigure_disksize do
    unsupported_reason_add(:reconfigure_disksize, 'Cannot resize disks of a VM with snapshots') if snapshots.count > 1
  end

  def provider_object(connection = nil)
    ManageIQ::Providers::Redhat::InfraManager::OvirtServices::V4.new(:ems => ext_management_system).get_vm_proxy(self, connection)
  end

  def self.display_name(number = 1)
    n_('Virtual Machine (Red Hat)', 'Virtual Machines (Red Hat)', number)
  end
end
