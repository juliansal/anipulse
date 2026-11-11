require "test_helper"
require "active_job/test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActiveJob::TestHelper

  driven_by :selenium_chrome_headless

  setup do
    # Ensure enqueued jobs (e.g. Catalog::AnimeIngestion::ProcessBatchJob) don't
    # run in a background thread during system tests.
    ActiveJob::Base.queue_adapter = :test
  end
end
