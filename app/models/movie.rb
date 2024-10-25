class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :genre, type: String
  field :year, type: Integer
  field :country, type: String
  field :published_at, type: Date
  field :description, type: String

  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :year, :genre, :country, :published_at, :description, presence: true
end
