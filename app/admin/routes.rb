ActiveAdmin.register Route do
  menu false
  actions :all, except: %i[new edit destroy]

  show title: :id do
    attributes_table do
      rows :id, :length, :user
      row('Comenzo', &:created_at)
      row('Termino', &:updated_at)
    end
  end
end
