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
  require_nested  :Storage
  require_nested  :Template
  require_nested  :Vm
  require_nested  :DistributedVirtualSwitch
  include_concern :ApiIntegration
  include_concern :VmImport
  include_concern :AdminUI

  include HasNetworkManagerMixin

  supports :catalog
  supports :create
  supports :metrics
  supports :provisioning
  supports :vm_import do
    # The version of the RHV needs to be at least 4.1.5 due to https://bugzilla.redhat.com/1477375
    unsupported_reason_add(:vm_import, _('Cannot import to a RHV provider of version < 4.1.5')) unless version_at_least?('4.1.5')
  end

  supports :admin_ui do
    # Link to oVirt Admin UI is supported for Engine version 4.1.8 or better.
    # See https://bugzilla.redhat.com/1512989 for details.
    unsupported_reason_add(:admin_ui, _('Admin UI is supported on version >= 4.1.8')) unless version_at_least?('4.1.8')
  end

  def self.ems_type
    @ems_type ||= "rhevm".freeze
  end

  def self.description
    @description ||= "Red Hat Virtualization".freeze
  end

  def self.catalog_types
    {"redhat" => N_("Red Hat Virtualization")}
  end

  def self.display_name(number = 1)
    n_('Infrastructure Provider (Red Hat)', 'Infrastructure Providers (Red Hat)', number)
  end
end
