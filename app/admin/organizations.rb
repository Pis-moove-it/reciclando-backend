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
    panel 'Usuarios' do
      table_for(organization.users) do |_user|
        column(:id) { |user| link_to(user.id, admin_user_path(user)) }
        column(:name, &:name)
        column(:ci, &:ci)
        tr class: 'action_items' do
          td link_to('Crear usuario', new_admin_organization_user_path(organization), class: :button)
        end
      end
    end
    panel 'Bolsones' do
      table_for(organization.pockets) do |_pocket|
        column(:id) { |pocket| link_to(pocket.id, admin_pocket_path(pocket)) }
        column(:serial_number, &:serial_number)
        column(:weight, &:weight)
        column(:state, No_pesado: 0, Pesado: 1, Clasificado: 2)
      end
    end
    panel 'Fardos' do
      table_for(organization.bales) do |_bale|
        column(:id) { |bale| link_to(bale.id, admin_bale_path(bale)) }
        column(:weight, &:weight)
        column(:material, Basura: 0, Plastico: 1, Vidrio: 2)
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
