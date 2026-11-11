module Catalog
  module AnimeIngestion
    class Batch < ApplicationRecord
      self.table_name = "catalog_anime_ingestion_batches"

      has_one :import,
        class_name: "Catalog::AnimeIngestion::Import",
        foreign_key: :anime_ingestion_batch_id,
        dependent: :destroy
      has_one_attached :csv_file

      validates :csv_file, attached: true
      validate :acceptable_csv
      before_validation :set_file_name

      enum :source, {
        file_upload: :file_upload,
        api_call: :api_call
      }, default: :file_upload

      enum :status, {
        pending: :pending,
        processing: :processing,
        completed: :completed,
        failed: :failed
      }, default: :pending

      private

      def acceptable_csv
        return unless csv_file.attached?

        unless csv_file.content_type.in?(%w[text/csv text/plain]) ||
               csv_file.filename.to_s.downcase.end_with?(".csv")
          errors.add(:csv_file, "must be a CSV file")
        end
      end

      def set_file_name
        self.file_name = csv_file.filename.to_s if csv_file.attached?
      end
    end
  end
end
