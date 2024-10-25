class MoviesController < ApplicationController
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
end
