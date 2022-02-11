ManageIQ::Providers::Ovirt::InfraManager::Host.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager::Host < ManageIQ::Providers::Ovirt::InfraManager::Host
  def provider_object(connection = nil)
    ManageIQ::Providers::Redhat::InfraManager::OvirtServices::V4.new(:ems => ext_management_system).get_host_proxy(self, connection)
  end

  supports :quick_stats do
    unless ext_management_system.supports?(:quick_stats)
      unsupported_reason_add(:quick_stats, 'RHV API version does not support quick_stats')
    end
  end

  def self.display_name(number = 1)
    n_('Host (Redhat)', 'Hosts (Redhat)', number)
  end
end
