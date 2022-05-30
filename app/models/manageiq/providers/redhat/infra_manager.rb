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

  supports :catalog
  supports :create
  supports :metrics
  supports :provisioning

  supports :create_iso_datastore do
    unsupported_reason_add(:create_iso_datastore, _("Already has an ISO datastore")) if iso_datastore
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
