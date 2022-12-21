class ManageIQ::Providers::Redhat::ConnectionManager < ManageIQ::Providers::Ovirt::ConnectionManager
  private

  #
  # Returns the settings of the connection manager.
  #
  # @return [Object] The `ems.ems_redhat.connection_manager` branch of the settings.
  #
  # @api private
  #
  def settings
    ::Settings.ems.ems_redhat.connection_manager
  end
end
