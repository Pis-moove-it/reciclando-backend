ActiveAdmin.register Container do
  permit_params :status, :active

  index do
    id_column
    column :status
    column :active
    actions
  end

  filter :status
  filter :active

  form do |f|
    f.inputs do
      f.input :status
      f.input :active unless f.object.new_record?
    end
    f.actions
  end
end
