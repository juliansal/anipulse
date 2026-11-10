class CreateCatalogAnimes < ActiveRecord::Migration[8.1]
  def change
    create_table :catalog_animes do |t|
      t.integer :anime_id, null: false
      t.string :name, null: false
      t.string :english_name
      t.string :other_name
      t.decimal :score, precision: 4, scale: 2
      t.string :genres
      t.text :synopsis
      t.string :media_type
      t.integer :episodes
      t.string :aired
      t.string :premiered
      t.string :status
      t.string :producers
      t.string :studios
      t.integer :popularity
      t.string :image_url

      t.timestamps

      t.index [ :anime_id, :name ], unique: true
    end
  end
end
