class ManageIQ::Providers::Redhat::Inventory::Parser::InfraManager < ManageIQ::Providers::Ovirt::Inventory::Parser::InfraManager

  def datacenters
    collector.datacenters.each do |datacenter|
      ems_ref = ManageIQ::Providers::Redhat::InfraManager.make_ems_ref(datacenter.href)

      persister.ems_folders.find_or_build('root_dc').assign_attributes(
        :name    => 'Datacenters',
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Folder',
        :uid_ems => 'root_dc',
        :hidden  => true,
        :parent  => nil,
      )

      uid = datacenter.id
      persister.ems_folders.find_or_build(ems_ref).assign_attributes(
        :name    => datacenter.name,
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Datacenter',
        :ems_ref => ems_ref,
        :uid_ems => uid,
        :parent  => persister.ems_folders.lazy_find("root_dc")
      )

      host_folder_uid = "#{uid}_host"
      persister.ems_folders.find_or_build(host_folder_uid).assign_attributes(
        :name    => 'host',
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Folder',
        :uid_ems => host_folder_uid,
        :hidden  => true,
        :parent  => persister.ems_folders.lazy_find(ems_ref)
      )

      vm_folder_uid = "#{uid}_vm"
      persister.ems_folders.find_or_build(vm_folder_uid).assign_attributes(
        :name    => 'vm',
        :type    => 'ManageIQ::Providers::Redhat::InfraManager::Folder',
        :uid_ems => vm_folder_uid,
        :hidden  => true,
        :parent  => persister.ems_folders.lazy_find(ems_ref)
      )
    end
  end

  def hosts
    collector.hosts.each do |host|
      host_id = host.id

      power_state = host.status
      power_state, connection_state = case power_state
                                      when 'up'             then %w(on connected)
                                      when 'maintenance'    then [power_state, 'connected']
                                      when 'down'           then %w(off disconnected)
                                      when 'non_responsive' then %w(unknown connected)
                                      else [power_state, 'disconnected']
                                      end

      hostname = host.address
      hostname = hostname.split(',').first

      nics = collector.collect_host_nics(host)
      ipaddress = host_to_ip(nics, hostname) || host.address

      host_os_version = host.dig(:os, :version)
      ems_ref = ManageIQ::Providers::Redhat::InfraManager.make_ems_ref(host.href)

      cluster = collector.collect_cluster_for_host(host)
      dc = collector.collect_datacenter_for_cluster(cluster)
      persister_host = persister.hosts.find_or_build(ems_ref).assign_attributes(
        :type             => 'ManageIQ::Providers::Redhat::InfraManager::Host',
        :ems_ref          => ems_ref,
        :name             => host.name || hostname,
        :hostname         => hostname,
        :ipaddress        => ipaddress,
        :uid_ems          => host_id,
        :vmm_vendor       => 'redhat',
        :vmm_product      => host.type,
        :vmm_version      => extract_host_version(host_os_version),
        :vmm_buildnumber  => (host_os_version.build if host_os_version),
        :connection_state => connection_state,
        :power_state      => power_state,
        :maintenance      => power_state == 'maintenance',
        :ems_cluster      => persister.clusters.lazy_find({:uid_ems => cluster.id}, :ref => :by_uid_ems),
      )

      host_storages(dc, persister_host)
      host_operating_systems(persister_host, host, hostname)
      network_attachments = collector.collect_network_attachments(host.id)
      switches(persister_host, dc, network_attachments)
      host_hardware(persister_host, host, networks, nics)
    end
  end

  def vms
    vms = Array(collector.vms) + Array(collector.templates)
    vms.compact.each do |vm|
      # Skip the place holder template
      next if vm.id == '00000000-0000-0000-0000-000000000000'

      template = vm.href.include?('/templates/')

      ems_ref = ManageIQ::Providers::Ovirt::InfraManager.make_ems_ref(vm.href)

      host_obj = vm.try(:host) || vm.try(:placement_policy).try(:hosts).try(:first)
      host_ems_ref = ManageIQ::Providers::Ovirt::InfraManager.make_ems_ref(host_obj.href) if host_obj.present?

      datacenter_id = collector.datacenter_by_cluster_id[vm.cluster.id]
      parent_folder = persister.ems_folders.lazy_find("#{datacenter_id}_vm")
      resource_pool = persister.resource_pools.lazy_find("#{vm.cluster.id}_respool") unless template
      host          = persister.hosts.lazy_find(host_ems_ref) if host_ems_ref.present?
      cpu_affinity  = vm.cpu&.cpu_tune&.vcpu_pins&.map { |pin| "#{pin.vcpu}##{pin.cpu_set}" }&.join(",")

      storages, disks = storages(vm)

      collection_persister = if template
                               persister.miq_templates
                             else
                               persister.vms
                             end

      attrs_to_assign = {
        :type             => template ? "ManageIQ::Providers::Redhat::InfraManager::Template" : "ManageIQ::Providers::Redhat::InfraManager::Vm",
        :ems_ref          => ems_ref,
        :uid_ems          => vm.id,
        :connection_state => "connected",
        :vendor           => "redhat",
        :name             => URI::DEFAULT_PARSER.unescape(vm.name),
        :location         => "#{vm.id}.ovf",
        :template         => template,
        :memory_limit     => extract_vm_memory_policy(vm, :max),
        :memory_reserve   => vm_memory_reserve(vm),
        :raw_power_state  => template ? "never" : vm.status,
        :host             => host,
        :ems_cluster      => persister.clusters.lazy_find({:uid_ems => vm.cluster.id}, :ref => :by_uid_ems),
        :storages         => storages,
        :storage          => storages.first,
        :parent           => parent_folder,
        :resource_pool    => resource_pool,
        :cpu_affinity     => cpu_affinity
      }

      attrs_to_assign[:restart_needed] = vm.next_run_configuration_exists unless template
      attrs_to_assign[:tools_status] = get_tools_status(vm) unless template

      boot_time = vm.try(:start_time)
      attrs_to_assign[:boot_time] = boot_time unless boot_time.nil?

      persister_vm = collection_persister.find_or_build(vm.id).assign_attributes(attrs_to_assign)

      snapshots(persister_vm, vm)
      vm_hardware(persister_vm, vm, disks, template, host)
      operating_systems(persister_vm, vm)
      custom_attributes(persister_vm, vm)
    end
  end
end
