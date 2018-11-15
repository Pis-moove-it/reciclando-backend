ActiveAdmin.register User do
  menu priority: 4

  belongs_to :organization, optional: true

  permit_params :ci, :name, :surname, :email, :organization_id

  form do |f|
    f.inputs 'Details' do
      f.semantic_errors(*f.user.errors.keys)
      f.input :ci, label: 'Ci'
      f.input :name, label: 'Name'
      f.input :surname, label: 'Surname'
      f.input :email, label: 'Email'
      f.input :organization_id, label: 'Organization id'
    end
    f.actions
  end

  filter :name
  filter :surname
  filter :ci
  filter :email
  filter :organization
  filter :created_at

  index do
    id_column
    column :name
    column :surname
    column :organization
    actions
  end

  show title: :name do
    attributes_table do
      rows :id, :name, :surname, :ci, :email, :organization
    end
  end
end
