FactoryBot.define do
  factory :collection do
    collection_point nil
    route nil
  end

  factory :collection_with_pockets, parent: :collection do
    after :create do |collection_with_pockets|
      create_list :pocket, 3, collection: collection_with_pockets
    end
  end
end
