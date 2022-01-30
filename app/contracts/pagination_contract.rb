class PaginationContract < Dry::Validation::Contract
  params do
    optional(:per_page).value(:integer) { gt?(0) }
    optional(:page).value(:integer) { gt?(0) }
    required(:collection)
  end

  rule(:page, :per_page, :collection) do
    chunks = values[:collection].in_groups_of(values[:per_page])
    key.failure("out of max boundary") if values[:page] > chunks.size
  end
end
