class Catalog::Anime < ApplicationRecord
  validates :anime_id, presence: true, numericality: { only_integer: true }
  validates :name, presence: true
  validates :anime_id, uniqueness: { scope: :name }
end
