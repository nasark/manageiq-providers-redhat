ManageIQ::Providers::Ovirt::NetworkManager::CloudNetwork.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork < ManageIQ::Providers::Ovirt::NetworkManager::CloudNetwork
  require_nested :Private
  require_nested :Public
end
