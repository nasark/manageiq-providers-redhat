class ManageIQ::Providers::Redhat::InfraManager::ProvisionViaIso < ManageIQ::Providers::Redhat::InfraManager::Provision
  include Cloning
  include Configuration
  include StateMachine
end
