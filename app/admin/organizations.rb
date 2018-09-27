ActiveAdmin.register Organization do
  permit_params :name, :password

  index do
    id_column
    column :name
    actions
  end

  show title: :name do
    attributes_table do
      rows :id, :name
    end
    panel 'Users' do
      table_for(organization.users) do |_user|
        column(:id) { |user| link_to(user.id, admin_user_path(user)) }
        column(:name, &:name)
        column(:ci, &:ci)
        tr class: 'action_items' do
          td link_to('Crear usuario', new_admin_organization_user_path(organization), class: :button)
        end
      end
    end
  end

  filter :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :password
    end
    f.actions
  end
end
