ActiveAdmin.register Pocket do
  permit_params :serial_number
  actions :index, :show, :edit, :update

  index do
    id_column
    column :serial_number
    column :state
    column :organization
    actions
  end

  filter :serial_number
  filter :state
  filter :organization

  show title: :serial_number do
    attributes_table do
      rows :id, :serial_number, :state, :organization
    end
  end

  form do |f|
    f.inputs do
      f.input :serial_number if f.object.persisted?
    end
    f.actions
  end

  show title: :id do
    attributes_table do
      rows :id, :serial_number, :state, :organization
    end
  end
end
