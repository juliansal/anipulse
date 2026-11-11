require "application_system_test_case"

class Catalog::AnimeIngestion::BatchesTest < ApplicationSystemTestCase
  setup do
    @catalog_anime_ingestion_batch = catalog_anime_ingestion_batches(:one)
  end

  test "viewing anime ingestion batches" do
    visit catalog_anime_ingestion_batches_path

    assert_selector "h1", text: "Anime ingestion batches"
    assert_text @catalog_anime_ingestion_batch.file_name
    assert_text "New anime ingestion batch"
  end

  test "viewing an anime ingestion batch" do
    visit catalog_anime_ingestion_batch_path(@catalog_anime_ingestion_batch)

    assert_text "File name:"
    assert_text @catalog_anime_ingestion_batch.file_name
    assert_text "Back to anime ingestion batches"
  end

  test "uploading a CSV batch" do
    visit new_catalog_anime_ingestion_batch_path

    attach_file "anime-file-input", file_fixture("anime_batches.csv").to_path, make_visible: true
    click_on "Upload File"

    assert_text "CSV uploaded and batch created"
    assert_text "anime_batches.csv"
  end

  test "destroying an anime ingestion batch" do
    visit catalog_anime_ingestion_batch_path(@catalog_anime_ingestion_batch)

    assert_difference "Catalog::AnimeIngestion::Batch.count", -1 do
      click_on "Destroy this anime ingestion batch"
      assert_text "Anime ingestion batch was successfully destroyed."
    end

    assert_selector "h1", text: "Anime ingestion batches"
  end
end
