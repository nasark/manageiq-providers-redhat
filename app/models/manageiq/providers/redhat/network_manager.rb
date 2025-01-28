ManageIQ::Providers::Ovirt::NetworkManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::NetworkManager < ManageIQ::Providers::Ovirt::NetworkManager
  include ManageIQ::Providers::Openstack::ManagerMixin
  include SupportsFeatureMixin

  class << self
    delegate :refresh_ems, :to => ManageIQ::Providers::Redhat::InfraManager
  end

  def self.ems_type
    @ems_type ||= "redhat_network".freeze
  end

  def self.description
    @description ||= "Redhat Network".freeze
  end
end
