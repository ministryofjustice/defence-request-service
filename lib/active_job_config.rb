require "rails_config"

class ActiveJobConfig
  def self.queue(name)
    [Settings.rails.active_job_queue_prefix, name, "queue"].join("_")
  end
end
