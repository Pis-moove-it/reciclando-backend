ActiveAdmin.register Pocket do
  permit_params :serial_number, :weight
  actions :index, :show, :edit, :update

  index do
    id_column
    column :serial_number
    column :weight
    column :state
    column :organization
    actions
  end

  filter :serial_number
  filter :weight
  filter :state
  filter :organization

  show title: :serial_number do
    attributes_table do
      rows :id, :serial_number, :weight, :state, :organization
    end
  end

  form do |f|
    f.inputs do
      f.input :serial_number
      f.input :weight if f.object.state == 'Weighed'
    end
    f.actions
  end
end
