ManageIQ::Providers::Ovirt::NetworkManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::NetworkManager < ManageIQ::Providers::Ovirt::NetworkManager
  include ManageIQ::Providers::Openstack::ManagerMixin
  include SupportsFeatureMixin

  def self.ems_type
    @ems_type ||= "redhat_network".freeze
  end

  def self.description
    @description ||= "Redhat Network".freeze
  end
end
