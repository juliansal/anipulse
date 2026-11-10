class CreateCatalogAnimeIngestionImports < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_anime_ingestion_imports do |t|
      t.references :anime_ingestion_batch, null: false,
        foreign_key: { to_table: :catalog_anime_ingestion_batches },
        index: { unique: true }
      t.string :status, default: "running", null: false
      t.integer :records_imported
      t.integer :records_failed
      t.json :row_errors, default: {}

      t.timestamps

      t.check_constraint "status IN ('running', 'completed', 'failed')", name: "imports_status_check"
    end
  end
end
