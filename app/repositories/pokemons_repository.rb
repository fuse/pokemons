require "csv"

class PokemonsRepository
  attr_reader :datasource_path

  def initialize(datasource_path: Rails.application.config.x.pokemons_datasource_path)
    @datasource_path = datasource_path
    load_data
  end

  #
  # Load data from datasource.
  # Intentionally let exception bubble to prevent app from booting if not properly set.
  #
  # @return [<Type>] <description>
  #
  def load_data
    lines = CSV.read(datasource_path, headers: true)
    @objects = lines.map do |line|
      Pokemon.new(Pokemon.attribute_keys.zip(line.fields).to_h)
    end
  end
  alias_method :reload, :load_data

  def find_by(attributes: {})
    # ensure attributes passed as arguments match struct attributes using intersection
    if Pokemon.has_all_attributes?(attributes.keys)
      collection.select do |pokemon|
        attributes.all? { |key, value| pokemon[key] == value }
      end
    else
      Rails.logger.debug "Unknown attributes from #{attributes}"
      []
    end
  end

  #
  # Dump objects as CSV. This is a really optimistic and naive implementation
  # which doesn't handle concurrent accesses.
  # It will also slightly update CSV headers.
  #
  # @return [<Type>] <description>
  #
  def dump
    File.open(datasource_path, "w+") do |file|
      file << "#{Pokemon.attribute_keys.join(',')}\n"
      collection.each do |object|
        file << "#{object.serialize}\n"
      end
    end
  end

  def insert(object)
    if object.is_a?(Pokemon)
      add(object)
      dump
      object
    else
      Rails.logger.debug("Can't insert something different than Pokemon.")
      nil
    end
  end

  #
  # Find objects matching given attributes and delete them.
  # We first remove them from memory then dump the remaining collection to CSV.
  # Careful as passing an empty hash will delete the whole collection.
  #
  # @param [<Hash>] attributes used to find objects to delete
  #
  # @return [<Pokemon|nil>] Deleted objects or nil
  #
  def delete(attributes:)
    objects = find_by(attributes: attributes)
    if objects.any?
      objects.each { |object| remove(object) }
      dump
      objects
    else
      Rails.logger.debug "Nothing to be deleted."
      nil
    end
  end

  def update(finding_attributes:, update_attributes:)
    if Pokemon.has_all_attributes?(update_attributes.keys)
      objects = find_by(attributes: finding_attributes)
      if objects.any?
        pokemons = objects.each_with_object([]) do |object, acc|
          # object are immutables, remove existing one and add new one
          pokemon = Pokemon.new(object.attributes.merge(update_attributes))
          remove(object)
          add(pokemon)
          acc << pokemon
        end
        # once every objects have been updated, dump to file
        dump
        pokemons
      else
        Rails.logger.debug "Nothing to be updated."
        nil
      end
    else
      Rails.logger.debug "Unknown attributes to update from #{update_attributes}"
      nil
    end
  end

  #
  # Add object to collection and return it.
  #
  # @param [<Type>] object <description>
  #
  # @return [<Type>] <description>
  #
  def add(object)
    if object.is_a?(Pokemon)
      collection << object
      object
    end
  end

  def remove(object)
    collection.delete(object)
  end

  def paginate(size = 10)
    collection.in_groups_of(size)
  end

  def all
    @objects ||= load_data
  end
  alias_method :collection, :all
end
