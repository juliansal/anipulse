require "test_helper"

class Catalog::AnimeIngestion::BatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @catalog_anime_ingestion_batch = catalog_anime_ingestion_batches(:one)
  end

  test "should get index" do
    get catalog_anime_ingestion_batches_url
    assert_response :success
  end

  test "should get new" do
    get new_catalog_anime_ingestion_batch_url
    assert_response :success
  end

  test "should create catalog_anime_ingestion_batch" do
    assert_difference("Catalog::AnimeIngestion::Batch.count") do
      post catalog_anime_ingestion_batches_url, params: { catalog_anime_ingestion_batch: { source: "file_upload", csv_file: fixture_file_upload("anime_batches.csv", "text/csv") } }
    end

    assert_redirected_to catalog_anime_ingestion_batch_url(Catalog::AnimeIngestion::Batch.last)
  end

  test "should show catalog_anime_ingestion_batch" do
    get catalog_anime_ingestion_batch_url(@catalog_anime_ingestion_batch)
    assert_response :success
  end

  test "should not allow updates" do
    patch catalog_anime_ingestion_batch_url(@catalog_anime_ingestion_batch),
      params: { catalog_anime_ingestion_batch: { source: "api_call" } }
    assert_response :not_found
  end

  test "should destroy catalog_anime_ingestion_batch" do
    assert_difference("Catalog::AnimeIngestion::Batch.count", -1) do
      delete catalog_anime_ingestion_batch_url(@catalog_anime_ingestion_batch)
    end

    assert_redirected_to catalog_anime_ingestion_batches_url
  end

  test "should create catalog_anime_ingestion_batch and enqueue processing" do
    assert_enqueued_with(job: Catalog::AnimeIngestion::ProcessBatchJob) do
      assert_difference("Catalog::AnimeIngestion::Batch.count") do
        post catalog_anime_ingestion_batches_url, params: {
          catalog_anime_ingestion_batch: {
            source: "file_upload",
            csv_file: fixture_file_upload("anime_batches.csv", "text/csv")
          }
        }
      end
    end

    assert_redirected_to catalog_anime_ingestion_batch_url(Catalog::AnimeIngestion::Batch.last)
  end
end
