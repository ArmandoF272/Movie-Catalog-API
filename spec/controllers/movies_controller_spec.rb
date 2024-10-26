# spec/controllers/movies_controller_spec.rb
require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'POST #import' do
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

    after do
      valid_file.close
      valid_file.unlink
      partially_invalid_file.close
      partially_invalid_file.unlink
      fully_invalid_file.close
      fully_invalid_file.unlink
      Movie.delete_all
    end

    it 'imports movies successfully with valid CSV' do
      file = fixture_file_upload(valid_file.path, 'text/csv')
      post :import, params: { file: file }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['status']).to eq('success')
      expect(Movie.count).to eq(1)
    end

    it 'returns partial success with partially invalid CSV' do
      file = fixture_file_upload(partially_invalid_file.path, 'text/csv')
      post :import, params: { file: file }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['status']).to eq('partial_success')
      expect(Movie.count).to eq(1)
    end

    it 'returns failure with fully invalid CSV' do
      file = fixture_file_upload(fully_invalid_file.path, 'text/csv')
      post :import, params: { file: file }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['status']).to eq('failure')
      expect(Movie.count).to eq(0)
    end
  end
end