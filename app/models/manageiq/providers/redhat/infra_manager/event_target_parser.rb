class ManageIQ::Providers::Redhat::InfraManager::EventTargetParser < ManageIQ::Providers::Ovirt::InfraManager::EventTargetParser
  private

  def add_vm_target(target_collection, vm_data)
    ems_ref = ManageIQ::Providers::Redhat::InfraManager.make_ems_ref(vm_data["href"])
    target_collection.add_target(:association => :vms, :manager_ref => {:ems_ref => ems_ref})
  end

  def add_template_target(target_collection, template_data)
    ems_ref = ManageIQ::Providers::Redhat::InfraManager.make_ems_ref(template_data["href"])
    target_collection.add_target(:association => :miq_templates, :manager_ref => {:ems_ref => ems_ref})
  end

  def add_cluster_target(target_collection, cluster_data)
    ems_ref = ManageIQ::Providers::Redhat::InfraManager.make_ems_ref(cluster_data["href"])
    target_collection.add_target(:association => :ems_clusters, :manager_ref => {:ems_ref => ems_ref})
  end
end
