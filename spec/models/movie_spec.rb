require 'rails_helper'
require 'csv'

RSpec.describe Movie, type: :model do
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

  describe '.import_from_csv' do
    context 'with valid CSV content' do
      it 'imports the movies successfully' do
        result = Movie.import_from_csv(valid_file.path)
        expect(result[:status]).to eq('success')
        expect(result[:message]).to eq('All movies were imported successfully')
        expect(Movie.count).to eq(1)
      end
    end

    context 'with partially invalid CSV content' do
      it 'returns partial success' do
        result = Movie.import_from_csv(partially_invalid_file.path)
        expect(result[:status]).to eq('partial_success')
        expect(result[:message]).to eq('Some movies were not imported')
        expect(Movie.count).to eq(1)
      end
    end

    context 'with fully invalid CSV content' do
      it 'returns failure' do
        result = Movie.import_from_csv(fully_invalid_file.path)
        expect(result[:status]).to eq('failure')
        expect(result[:message]).to eq('No movies were imported')
        expect(Movie.count).to eq(0)
      end
    end
  end

  describe '.return_message' do
    it 'returns success message if no failures' do
      result = Movie.return_message([], 1)
      expect(result[:status]).to eq('success')
      expect(result[:message]).to eq('All movies were imported successfully')
    end

    it 'returns failure message if all rows failed' do
      failures = [{ show_id: '1', title: 'Movie Title', error: 'error message' }]
      result = Movie.return_message(failures, 1)
      expect(result[:status]).to eq('failure')
      expect(result[:message]).to eq('No movies were imported')
    end

    it 'returns partial success message if some rows failed' do
      failures = [{ show_id: '1', title: 'Movie Title', error: 'error message' }]
      result = Movie.return_message(failures, 2)
      expect(result[:status]).to eq('partial_success')
      expect(result[:message]).to eq('Some movies were not imported')
      expect(result[:failures]).to eq(failures)
    end
  end
end