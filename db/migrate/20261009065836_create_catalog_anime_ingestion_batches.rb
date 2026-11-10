class CreateCatalogAnimeIngestionBatches < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_anime_ingestion_batches do |t|
      t.string :file_name, null: false
      t.string :source, default: :file_upload, null: false
      t.string :status, default: :pending, null: false
      t.integer :records_processed
      t.integer :records_failed
      t.string :error_log

      t.check_constraint "source IN ('file_upload', 'api_call')", name: :batches_source_check
      t.check_constraint "status IN ('pending', 'processing', 'completed', 'failed')", name: :batches_status_check

      t.timestamps
    end
  end
end
