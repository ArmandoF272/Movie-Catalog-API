class MoviesController < ApplicationController

  def index
    movies = Movie.all
    movies = filter_movies(movies, params)
    render json: movies.map { |movie| movie_json(movie) }
  end

  private
    def movie_json(movie)
      {
        id: movie.id.to_s,
        title: movie.title,
        genre: movie.genre,
        year: movie.year,
        country: movie.country,
        published_at: movie.published_at,
        description: movie.description
      }
    end

    def filter_movies(movies, params)
      movies = movies.where(year: params[:year]) if params[:year].present?
      movies = movies.where(genre: params[:genre]) if params[:genre].present?
      movies = movies.where(country: params[:country]) if params[:country].present?
      movies = movies.where(published_at: params[:published_at]) if params[:published_at].present?
      movies = movies.where(description: params[:description]) if params[:description].present?
      movies.order_by(year: :asc)
    end
end
