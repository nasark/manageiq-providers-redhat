class ManageIQ::Providers::Redhat::InfraManager::Vm
  module RemoteConsole
    extend ActiveSupport::Concern

    included do
      supports :native_console
      # NOTE: this all says that these are supported IF html_console is enabled
      supports(:html5_console) { _("Html5 console is disabled by default, check settings to enable it") unless html5_console_enabled? }
      supports(:console)       { unsupported_reason(:html5_console) }
      supports(:spice_console) { unsupported_reason(:html5_console) }
      supports(:vnc_console)   { unsupported_reason(:html5_console) }
    end

    def validate_remote_console_acquire_ticket(protocol, options = {})
      raise(MiqException::RemoteConsoleNotSupportedError,
            "#{protocol} protocol not enabled for this vm") unless protocol.to_sym == :html5

      raise(MiqException::RemoteConsoleNotSupportedError,
            "Html5 console is disabled by default, check settings to enable it") unless html5_console_enabled?

      raise(MiqException::RemoteConsoleNotSupportedError,
            "#{protocol} remote console requires the vm to be registered with a management system.") if ext_management_system.nil?

      options[:check_if_running] = true unless options.key?(:check_if_running)
      raise(MiqException::RemoteConsoleNotSupportedError,
            "#{protocol} remote console requires the vm to be running.") if options[:check_if_running] && state != "on"
    end
  end

  private

  def html5_console_enabled?
    !!::Settings.ems.ems_redhat&.consoles&.html5_enabled
  end
end
