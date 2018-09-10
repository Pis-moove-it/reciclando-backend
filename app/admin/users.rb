ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

#permit_params :ci, :name, :surname, :email

permit_params :ci, 
            :name,
            :surname,
            :email,
            :organization_id

        form do |f|

            ### Declare here the model's own form fields:
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
