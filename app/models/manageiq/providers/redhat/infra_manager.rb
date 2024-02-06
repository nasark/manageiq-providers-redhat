ManageIQ::Providers::Ovirt::InfraManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager < ManageIQ::Providers::Ovirt::InfraManager
  has_many :cloud_tenants, :foreign_key => :ems_id, :dependent => :destroy
  has_many :vm_and_template_ems_custom_fields, :through => :vms_and_templates, :source => :ems_custom_attributes
  has_many :external_distributed_virtual_switches, :dependent => :destroy, :foreign_key => :ems_id, :inverse_of => :ext_management_system
  has_many :external_distributed_virtual_lans, -> { distinct }, :through => :external_distributed_virtual_switches, :source => :lans
  has_many :iso_datastores, :dependent => :destroy, :foreign_key => :ems_id, :inverse_of => :ext_management_system
  has_many :iso_images, :through => :storages

  has_one :network_manager,
          :foreign_key => :parent_ems_id,
          :class_name  => "ManageIQ::Providers::Redhat::NetworkManager",
          :autosave    => true,
          :inverse_of  => :parent_manager,
          :dependent   => :destroy

  supports :catalog
  supports :create
  supports :metrics
  supports :provisioning

  def self.ems_type
    @ems_type ||= "rhevm".freeze
  end

  def self.description
    @description ||= "Red Hat Virtualization".freeze
  end

  def self.vm_vendor
    "redhat".freeze
  end

  def self.host_vendor
    "redhat".freeze
  end

  def self.catalog_types
    {"redhat" => N_("Red Hat Virtualization")}
  end

  def self.display_name(number = 1)
    n_('Infrastructure Provider (Red Hat)', 'Infrastructure Providers (Red Hat)', number)
  end

  def self.ems_settings
    ::Settings.ems.ems_redhat
  end

  def self.ems_refresh_settings
    ::Settings.ems_refresh.rhevm
  end
end
