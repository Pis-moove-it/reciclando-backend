ActiveAdmin.register Bale do
  permit_params :weight, :material, :organization_id, :user_id

  filter :weight
  filter :material, as: :select, collection: {Basura:0, Plastico:1, Vidrio:2}
  filter :organization

  index do
    id_column
    column :weight
    column :material
    column :organization
    column :user
    actions
  end

  show title: :id do
    attributes_table do
      rows :id, :weight, :material, :organization, :user
    end
  end

  form do |f|
    f.inputs do
      if f.object.new_record?
        f.input :user, as: :select, collection: User.all.map { |u| ["#{u.name} #{u.surname}", u.id] }
      end
      f.input :weight
      f.input :material
    end
    f.actions
  end
end
