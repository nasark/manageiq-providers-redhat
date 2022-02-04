class ManageIQ::Providers::Redhat::InfraManager::ProvisionWorkflow < ManageIQ::Providers::Ovirt::InfraManager::ProvisionWorkflow
  def self.provider_model
    ManageIQ::Providers::Redhat::InfraManager
  end

  def filter_allowed_hosts(all_hosts)
    ems = source_ems
    return all_hosts unless ems
    ManageIQ::Providers::Redhat::InfraManager::OvirtServices::V4.new(:ems => ems)
                                                                .filter_allowed_hosts(self, all_hosts)
  end

  def dialog_field_visibility_service
    @dialog_field_visibility_service ||= ManageIQ::Providers::Redhat::DialogFieldVisibilityService.new
    @dialog_field_visibility_service
  end
end
