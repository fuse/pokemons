class Api::V1::PokemonsController < ApplicationController
  before_action :initialize_repository
  before_action :set_update_attributes, only: :update

  def index
    contract = PaginationContract.new
    validator = contract.call(
      page: params[:page] || 1,
      per_page: params[:per_page] || Rails.application.config.x.default_per_page,
      collection: @repository.collection
    )

    if validator.errors.any?
      render json: validator.errors.to_h, status: :bad_request
    else
      chunks = validator[:collection].in_groups_of(validator[:per_page])
      render json: chunks[validator[:page] - 1].compact
    end
  end

  def create
    pokemon = Pokemon.new(
      id: params[:id],
      name: params[:name],
      type_1: params[:type_1], # rubocop:disable Naming/VariableNumber
      type_2: params[:type_2], # rubocop:disable Naming/VariableNumber
      total: params[:total],
      hp: params[:hp],
      attack: params[:attack],
      defense: params[:defense],
      sp_atk: params[:sp_atk],
      sp_def: params[:sp_def],
      speed: params[:speed],
      generation: params[:generation],
      legendary: params[:legendary]
    )

    if @repository.insert(pokemon)
      render json: pokemon.to_json
    else
      head :internal_server_error
    end
  rescue Dry::Struct::Error
    head :unprocessable_entity
  end

  def show
    pokemons = @repository.find_by(attributes: { id: params[:id].to_i })
    if pokemons.any?
      render json: pokemons.to_json
    else
      head :not_found
    end
  end

  def update
    id = params.delete(:id).to_i # TODO: deal with nil values leading to 0
    pokemons = @repository.update(finding_attributes: { id: id },
                                  update_attributes: @update_attributes)
    if pokemons
      render json: pokemons.to_json
    else
      head :unprocessable_entity
    end
  end

  def destroy
    if @repository.delete(attributes: { id: params[:id].to_i })
      head :no_content
    else
      head :not_found
    end
  end

  private

  def set_update_attributes
    @update_attributes = params.permit(
      :id,
      :name,
      :type_1,
      :type_2,
      :total,
      :hp,
      :attack,
      :defense,
      :sp_atk,
      :sp_def,
      :speed,
      :generation,
      :legendary
    ).to_h.symbolize_keys
  end

  def initialize_repository
    @repository = PokemonsRepository.new
  end
end
