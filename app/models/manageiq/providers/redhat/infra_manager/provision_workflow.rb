class ManageIQ::Providers::Redhat::InfraManager::ProvisionWorkflow < ManageIQ::Providers::Ovirt::InfraManager::ProvisionWorkflow
  def self.provider_model
    ManageIQ::Providers::Redhat::InfraManager
  end

  def dialog_name_from_automate(message = 'get_dialog_name')
    super(message, {'platform' => 'redhat'})
  end
end
