require "csv"

class Catalog::AnimeIngestion::ProcessBatch
  MAX_STORED_ROW_ERRORS = 100
  REQUIRED_HEADERS = %w[anime_id name]

  class MissingHeaders < StandardError; end

  def self.call(batch)
    new(batch).call
  end

  def initialize(batch)
    @batch = batch
    @import = Catalog::AnimeIngestion::Import.find_or_initialize_by(batch: batch)
  end

  def call
    @batch.update!(status: :processing)
    broadcast_batch_update
    reset_import!

    @batch.csv_file.open do |file|
      process_rows(file)
    end

    finalize(:completed)

  rescue StandardError => e
    finalize(:failed, e.message)
    raise
  end

  private

  def reset_import!
    @imported = 0
    @failed = 0
    @row_errors = {}
    @import.assign_attributes(status: :running, records_imported: 0, records_failed: 0, row_errors: {})
    @import.save!
  end

  def process_rows(file)
    Catalog::Anime.transaction do
      CSV.foreach(file, headers: true, liberal_parsing: true).with_index(2) do |row, line_number|
        validate_headers!(row.headers) if line_number == 2
        import_row(row, line_number)
      end
    end
  rescue StandardError
    @imported = 0
    @failed = 0
    @row_errors = {}
    raise
  end

  def validate_headers!(raw_headers)
    normalized = raw_headers.map { |h| h.to_s.strip.downcase.tr(" ", "_") }
    missing = REQUIRED_HEADERS - normalized
    raise MissingHeaders, "missing required columns: #{missing.join(', ')}" if missing.any?
  end

  def import_row(csv_row, line_number)
    fields = csv_row.to_h.transform_keys { |k| k.to_s.strip.downcase.tr(" ", "_") }

    anime = Catalog::Anime.find_or_initialize_by(anime_id: fields["anime_id"], name: fields["name"])

    (Catalog::Anime.attribute_names - %w[id anime_id name created_at updated_at])
      .each { |attr| anime[attr] = fields[attr] }

    anime.save!

    @imported += 1
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
    @failed += 1
    store_row_error(line_number, e)
  end

  def store_row_error(line_number, error)
    return if @failed > MAX_STORED_ROW_ERRORS

    @row_errors[line_number.to_s] = error.message
  end

  def finalize(status, error = nil)
    @import.assign_attributes(
      status: status,
      records_imported: @imported,
      records_failed: @failed,
      row_errors: @row_errors
    )
    @import.save!

    @batch.assign_attributes(
      status: status,
      records_processed: @imported,
      records_failed: @failed,
      error_log: error
    )
    @batch.save!
    broadcast_batch_update
  end

  def broadcast_batch_update
    @batch.broadcast_replace_to(
      @batch,
      target: @batch,
      partial: "catalog/anime_ingestion/batches/batch",
      locals: { batch: @batch }
    )
  end
end
