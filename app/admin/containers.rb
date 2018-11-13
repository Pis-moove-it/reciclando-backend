ActiveAdmin.register Container do
  menu priority: 8

  actions :all, except: %i[new edit destroy]

  index do
    id_column
    column :status
    column :active
    column :organization
    actions
  end

  filter :status
  filter :active

  show title: :id do
    attributes_table do
      rows :id, :latitude, :longitude, :created_at, :updated_at, :status,
           :active, :organization
    end

    panel 'Levantadas de bolsones' do
      table_for(container.collections) do |_collection|
        column(:id) { |collection| link_to(collection.id, admin_collection_path(collection.id)) }
        column(:created_at, &:created_at)
        column(:weight) { |collection| collection.pockets.pluck(:weight).map { |weight| weight || 0 }.sum.round }
        column(:route) do |collection|
          link_to(collection.route.id, admin_route_path(collection.route.id))
        end
      end
    end
  end
end
