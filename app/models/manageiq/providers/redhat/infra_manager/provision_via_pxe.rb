class ManageIQ::Providers::Redhat::InfraManager::ProvisionViaPxe < ManageIQ::Providers::Redhat::InfraManager::Provision
  include Cloning
  include Configuration
  include StateMachine
end
