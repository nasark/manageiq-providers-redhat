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

  def ensure_managers
    return unless enabled
    ensure_network_manager
    if network_manager
      network_manager.name = "#{name} Network Manager"
      network_manager.zone_id = zone_id
      network_manager.provider_region = provider_region
      network_manager.tenant_id = tenant_id
      network_manager.save!
    end
  end

  def ensure_network_manager
    providers = ovirt_services.collect_external_network_providers

    unless providers.blank?
      providers = providers.sort_by(&:name)
      auth_url = providers.first.authentication_url
    end

    if auth_url
      if network_manager.nil?
        ems_was_removed = false

        if id # before update
          ems = ExtManagementSystem.find_by(:id => id)
          ems_was_removed = ems.nil? || !ems.enabled
        end

        unless ems_was_removed
          build_network_manager(:type => 'ManageIQ::Providers::Redhat::NetworkManager')
        end
      end

      if network_manager
        populate_network_manager_connectivity(auth_url)
      end
    elsif network_manager
      network_manager.destroy_queue
    end
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
