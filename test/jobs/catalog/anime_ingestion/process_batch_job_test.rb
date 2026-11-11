require "test_helper"
require "turbo/broadcastable/test_helper"

class Catalog::AnimeIngestion::ProcessBatchJobTest < ActiveJob::TestCase
  include Turbo::Broadcastable::TestHelper
  test "broadcasts a replace stream for each batch status update" do
    batch = Catalog::AnimeIngestion::Batch.create!(
      csv_file: Rack::Test::UploadedFile.new(file_fixture("anime_batches.csv"), "text/csv")
    )

    # ProcessBatch broadcasts once when status → :processing and once on finalize
    assert_turbo_stream_broadcasts batch, count: 2 do
      Catalog::AnimeIngestion::ProcessBatchJob.perform_now(batch)
    end

    assert_equal "replace", capture_turbo_stream_broadcasts(batch).first["action"]
  end
end
