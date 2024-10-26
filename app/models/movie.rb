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

  def self.import_from_csv(file_path)

    failure_list = []
    rows = CSV.foreach(file_path, headers: true)

    rows.each do |row|
      movie_data = row.to_hash
      movie = Movie.where(show_id: movie_data["show_id"]).last

      unless movie.present?
        movie = create(show_id: movie_data["show_id"]) do |movie|
          movie.title = movie_data["title"]
          movie.genre = movie_data["listed_in"].split(",").map(&:strip)
          movie.year = movie_data["release_year"]
          movie.country = movie_data["country"]
          movie.published_at = movie_data["date_added"]
          movie.description = movie_data["description"]
          movie.type = movie_data["type"]
          movie.director = movie_data["director"]
          movie.cast = movie_data["cast"]
          movie.rating = movie_data["rating"]
          movie.duration = movie_data["duration"]
        end
      else
        failure_list << { show_id: movie_data["show_id"], title: movie_data["title"], error: "Already exists" }
      end

      unless movie.persisted?
        failure_list << { show_id: movie_data["show_id"], title: movie_data["title"] , error: movie.errors.full_messages.join(", ") }
      end
    end

    return_message(failure_list, rows.count)
  end

  def self.return_message(failure_list, rows_size)
    case failure_list.size
    when 0
      { status: "success", message: "All movies were imported successfully" }
    when rows_size
      { status: "failure", message: "No movies were imported" }
    else
      { status: "partial_success",
        message: "Some movies were not imported",
        failures: failure_list }
    end
  end
end
