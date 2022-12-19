ManageIQ::Providers::Ovirt::InfraManager.include(ActsAsStiLeafClass)

class ManageIQ::Providers::Redhat::InfraManager < ManageIQ::Providers::Ovirt::InfraManager
  require_nested  :Cluster
  require_nested  :Datacenter
  require_nested  :EventCatcher
  require_nested  :EventParser
  require_nested  :EventTargetParser
  require_nested  :Folder
  require_nested  :RefreshWorker
  require_nested  :Refresher
  require_nested  :ResourcePool
  require_nested  :MetricsCapture
  require_nested  :MetricsCollectorWorker
  require_nested  :Host
  require_nested  :Provision
  require_nested  :ProvisionViaIso
  require_nested  :ProvisionViaPxe
  require_nested  :ProvisionWorkflow
  require_nested  :Snapshot
  require_nested  :Storage
  require_nested  :IsoDatastore
  require_nested  :Template
  require_nested  :Vm
  require_nested  :DistributedVirtualSwitch

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
