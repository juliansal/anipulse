class Catalog::Anime < ApplicationRecord
  validates :anime_id, presence: true, numericality: { only_integer: true }
  validates :name, presence: true
end
