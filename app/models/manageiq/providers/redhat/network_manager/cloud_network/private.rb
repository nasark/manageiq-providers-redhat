class ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork::Private < ManageIQ::Providers::Redhat::NetworkManager::CloudNetwork
  def self.display_name(number = 1)
    n_('Cloud Network (Redhat)', 'Cloud Networks (Redhat)', number)
  end
end
