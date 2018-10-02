ActiveAdmin.register Pocket do
  actions :index

  index do
    id_column
    column :serial_number
    column :state
    column :organization
  end
end
