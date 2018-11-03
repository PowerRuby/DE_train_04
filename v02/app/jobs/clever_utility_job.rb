class CleverUtilityJob < ApplicationJob
  queue_as :default

  def perform(*args)
    sleep 15
    logger.info "Logging this message after a delay of 15 seconds."
  end
end
