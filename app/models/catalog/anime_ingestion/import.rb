
module Catalog
  module AnimeIngestion
    class Import < ApplicationRecord
      self.table_name = "catalog_anime_ingestion_imports"

      belongs_to :batch,
        class_name: "Catalog::AnimeIngestion::Batch",
        foreign_key: :anime_ingestion_batch_id

      enum :status, { running: :running, completed: :completed, failed: :failed }, default: :running

      validates :batch, uniqueness: true
    end
  end
end
