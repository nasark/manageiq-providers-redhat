module ManageIQ::Providers::Redhat::InfraManager::VmOrTemplateShared::Scanning
  extend ActiveSupport::Concern

  def scan_job_class
    ManageIQ::Providers::Redhat::InfraManager::Scanning::Job
  end

  # Moved from MIQExtract.rb
  # TODO: Should this be in the ems?
  def connect_to_ems(ost)
    log_header = "MIQ(#{self.class.name}.#{__method__})"

    # Check if we've been told explicitly not to connect to the ems
    # TODO: See vm_scan.rb: config_ems_list() - is this always false for RedHat?
    if ost.scanData.fetch_path("ems", 'connect') == false
      $log.debug "#{log_header}: returning, ems/connect == false"
      return
    end

    st = Time.now
    ems_display_text = "ems(directly):#{ext_management_system.address}"
    $log.info "#{log_header}: Connecting to [#{ems_display_text}] for VM:[#{@vm_cfg_file}]"

    begin
      ost.miqRhevm = ManageIQ::Providers::Redhat::Inventory::Collector.new(ext_management_system, nil)
      $log.info "Connection to [#{ems_display_text}] completed for VM:[#{@vm_cfg_file}] in [#{Time.now - st}] seconds"
    rescue Timeout::Error => err
      msg = "#{log_header}: Connection to [#{ems_display_text}] timed out for VM:[#{@vm_cfg_file}] with error [#{err}] after [#{Time.now - st}] seconds"
      $log.error msg
      raise
    rescue Exception => err
      msg = "#{log_header}: Connection to [#{ems_display_text}] failed for VM:[#{@vm_cfg_file}] with error [#{err}] after [#{Time.now - st}] seconds"
      $log.error msg
      raise
    end
  end
end
