ActiveAdmin.register User do
    belongs_to :organization, optional: true
    permit_params :ci, :name, :surname, :email, :organization_id, organization_attributes: [:id, :name]

    form do |f|
        f.inputs "Details" do
            f.input :ci, label: "User ci"
            f.input :name, label: "User name"
            f.input :surname, label: "User surname"
            f.input :email, label: "User email"
            f.input :organization_id, label: "Organization id" 
        end
        f.actions
    end
end
