require 'manageiq/providers/ovirt/legacy/event_monitor'

class ManageIQ::Providers::Redhat::InfraManager::EventCatcher::Runner < ManageIQ::Providers::Ovirt::InfraManager::EventCatcher::Runner
  def queue_event(event)
    _log.info "#{log_prefix} Caught event [#{event.name}]"
    parser = ManageIQ::Providers::Redhat::InfraManager::EventParser
    event_hash = parser.event_to_hash(event, @cfg[:ems_id])
    EmsEvent.add_queue('add', @cfg[:ems_id], event_hash)
  end
end
