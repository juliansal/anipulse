require "test_helper"

class Catalog::AnimeIngestion::ProcessBatchJobTest < ActiveJob::TestCase
  assert_broadcast_on(Turbo.signed_stream_id(batch), action: :replace) do
    Catalog::AnimeIngestion::ProcessBatchJob.perform_now(batch)
  end
end
