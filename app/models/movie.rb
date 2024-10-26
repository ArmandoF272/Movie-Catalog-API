class Movie
  include Mongoid::Document
  include Mongoid::Timestamps

  field :show_id, type: String
  field :title, type: String
  field :genre, type: Array
  field :year, type: Integer
  field :country, type: String
  field :published_at, type: Date
  field :description, type: String
  field :type, type: String
  field :director, type: String
  field :cast, type: String
  field :release_year, type: Integer
  field :rating, type: String
  field :duration, type: String
  field :listed_in, type: String

  validates :show_id, presence: true, uniqueness: { case_sensitive: false }
  validates :title, :description, presence: true
end
