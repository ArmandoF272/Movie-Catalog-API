require 'rails_helper'

RSpec.describe "Movies", type: :request do
  describe "POST /movies/import" do
    let(:valid_csv_content) do
      <<~CSV
        show_id,title,listed_in,release_year,country,date_added,description,type,director,cast,rating,duration
        1,Movie Title,Drama,2020,USA,2020-01-01,Description of the movie,Movie,Director Name,Cast Name,PG-13,120 min
      CSV
    end

    let(:partially_invalid_csv_content) do
      <<~CSV
        show_id,title,listed_in,release_year,country,date_added,description,type,director,cast,rating,duration
        1,Movie Title,Drama,2020,USA,2020-01-01,Description of the movie,Movie,Director Name,Cast Name,PG-13,120 min
        2,,Drama,2020,USA,2020-01-01,,Movie,Director Name,Cast Name,PG-13,120 min
      CSV
    end

    let(:fully_invalid_csv_content) do
      <<~CSV
        show_id,title,listed_in,release_year,country,date_added,description,type,director,cast,rating,duration
        2,,Drama,2020,USA,2020-01-01,,Movie,Director Name,Cast Name,PG-13,120 min
        3,,Drama,2020,USA,2020-01-01,,Movie,Director Name,Cast Name,PG-13,120 min
      CSV
    end

    let(:valid_file) do
      file = Tempfile.new('valid_movies.csv')
      file.write(valid_csv_content)
      file.rewind
      file
    end

    let(:partially_invalid_file) do
      file = Tempfile.new('partially_invalid_movies.csv')
      file.write(partially_invalid_csv_content)
      file.rewind
      file
    end

    let(:fully_invalid_file) do
      file = Tempfile.new('fully_invalid_movies.csv')
      file.write(fully_invalid_csv_content)
      file.rewind
      file
    end
  end
end