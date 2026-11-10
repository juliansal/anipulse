json.extract! batch, :id, :file_name, :source, :status, :records_processed, :records_failed, :error_log, :created_at, :updated_at
json.url catalog_anime_ingestion_batch_url(batch, format: :json)
