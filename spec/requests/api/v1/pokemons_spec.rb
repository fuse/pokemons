require "rails_helper"

RSpec.describe "Api::V1::Pokemons", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/pokemons/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    context "with valid params" do
      let(:params) do
        {
          id: 898,
          name: "Martin",
          type_1: "Air",
          type_2: "Ground",
          total: 600,
          hp: 80,
          attack: 100,
          defense: 200,
          sp_atk: 50,
          sp_def: 100,
          speed: 30,
          generation: 8,
          legendary: true
        }
      end

      it "returns http success" do
        post "/api/v1/pokemons/", params: params
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      let(:params) { {} }

      it "returns http 422" do
        post "/api/v1/pokemons/", params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /get" do
    context "with valid params" do
      it "returns http success" do
        get "/api/v1/pokemons/1"
        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid params" do
      it "returns http success" do
        get "/api/v1/pokemons/4242"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /update" do
    let(:params) do
      {
        id: 1,
        name: "Martin",
        type_1: "Air",
        type_2: "Ground",
        total: 600,
        hp: 80,
        attack: 100,
        defense: 200,
        sp_atk: 50,
        sp_def: 100,
        speed: 30,
        generation: 8,
        legendary: true
      }
    end

    it "returns http success" do
      put "/api/v1/pokemons/666", params: params
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      delete "/api/v1/pokemons/1"
      expect(response).to have_http_status(:no_content)
    end
  end
end
