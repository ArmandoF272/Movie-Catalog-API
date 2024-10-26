  require 'rails_helper'

RSpec.describe "Movies", type: :request do
  describe "GET /import" do
    it "returns http success" do
      get "/movies/import"
      expect(response).to have_http_status(:success)
    end
  end

end
