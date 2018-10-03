ActiveAdmin.register Pocket do
  permit_params :serial_number

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

  form do |f|
    f.inputs do
      f.input :serial_number if f.object.persisted?
      if f.object.new_record?
        f.input :serial_number
        f.input :state
        f.input :organization
      end
    end
    f.actions
  end

  show title: :id do
    attributes_table do
      rows :id, :serial_number, :state, :organization
    end
  end
end
