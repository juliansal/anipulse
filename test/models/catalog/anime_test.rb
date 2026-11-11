require "test_helper"

class Catalog::AnimeTest < ActiveSupport::TestCase
  test "rejects duplicate anime_id scoped to name" do
    Catalog::Anime.create!(anime_id: 1, name: "Frieren")
    dup = Catalog::Anime.new(anime_id: 1, name: "Frieren")
    assert_raises ActiveRecord::RecordNotUnique do
      dup.save
    end
  end
end
