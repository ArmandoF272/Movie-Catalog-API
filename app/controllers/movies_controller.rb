class MoviesController < ApplicationController
  require 'csv'

  def index
    movies = Movie.all
    movies = filter_movies(movies, params)
    render json: movies.map { |movie| movie_json(movie) }
  end

  def import
    file_path = params.values.find { |value| value.is_a?(ActionDispatch::Http::UploadedFile) }&.tempfile&.path

    if file_path.present?
      result = Movie.import_from_csv(file_path)
      render json: result.except(:code), status: result[:code]
    else
      render json: { error: 'No file provided' }, status: :bad_request
    end
  end

  private
    def movie_json(movie)
      {
        id: movie.id.to_s,
        title: movie.title,
        genre: movie.genre.join(", "),
        year: movie.year,
        country: movie.country,
        published_at: movie.published_at,
        description: movie.description
      }
    end

    def filter_movies(movies, params)
      movies = movies.where(year: params[:year]) if params[:year].present?
      movies = movies.where(:genre.in => [params[:genre]]) if params[:genre].present?
      movies = movies.where(country: params[:country]) if params[:country].present?
      movies = movies.where(published_at: params[:published_at]) if params[:published_at].present?
      movies = movies.where(description: params[:description]) if params[:description].present?
      movies.order_by(year: :asc)
    end
end
