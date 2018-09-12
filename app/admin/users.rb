ActiveAdmin.register User do
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
end
