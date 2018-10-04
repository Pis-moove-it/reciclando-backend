ActiveAdmin.register Pocket do
  actions :index

  index do
    id_column
    column :serial_number
    column :state
    column :organization
  end

  show title: :id do
    attributes_table do
      rows :id, :serial_number, :state, :organization
    end
  end
end
