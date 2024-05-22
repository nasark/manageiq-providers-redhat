ManageIQ::Providers::Ovirt::InfraManager::Template.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager::Template < ManageIQ::Providers::Ovirt::InfraManager::Template
  include ManageIQ::Providers::Redhat::InfraManager::VmOrTemplateShared

  supports :provisioning do
    if ext_management_system
      ext_management_system.unsupported_reason(:provisioning)
    else
      _('not connected to ems')
    end
  end

  supports :kickstart_provisioning

  def provider_object(connection = nil)
    ManageIQ::Providers::Redhat::InfraManager::OvirtServices::V4.new(:ems => ext_management_system).get_template_proxy(self, connection)
  end
end
