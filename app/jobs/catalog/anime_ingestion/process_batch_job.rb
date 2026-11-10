class Catalog::AnimeIngestion::ProcessBatchJob < ApplicationJob
  queue_as :default

  def perform(batch)
    Catalog::AnimeIngestion::ProcessBatch.call(batch)
  end
end
