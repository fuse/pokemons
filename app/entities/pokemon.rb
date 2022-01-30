class Pokemon < Dry::Struct
  # we consider every attributes and values as required, except for type 2 value
  # which is already blank sometimes
  attribute :id, Dry.Types::Coercible::Integer
  attribute :name, Dry.Types::String
  attribute :type_1, Dry.Types::String # rubocop:disable Naming/VariableNumber
  attribute :type_2, Dry.Types::String.optional # rubocop:disable Naming/VariableNumber
  attribute :total, Dry.Types::Coercible::Integer
  attribute :hp, Dry.Types::Coercible::Integer
  attribute :attack, Dry.Types::Coercible::Integer
  attribute :defense, Dry.Types::Coercible::Integer
  attribute :sp_atk, Dry.Types::Coercible::Integer
  attribute :sp_def, Dry.Types::Coercible::Integer
  attribute :speed, Dry.Types::Coercible::Integer
  attribute :generation, Dry.Types::Coercible::Integer
  attribute :legendary, Dry.Types::Params::Bool

  def self.attribute_keys
    schema.keys.map(&:name)
  end

  def self.has_all_attributes?(keys)
    (keys & attribute_keys).size == keys.size
  end

  def serialize
    to_h.values.join(",")
  end
end
