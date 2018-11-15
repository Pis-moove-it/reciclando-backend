ActiveAdmin.register Question do
  menu priority: 10

  permit_params :question, :option_a, :option_b, :option_c, :option_d, :correct_option

  index do
    id_column
    column :question
    column :option_a
    column :option_b
    column :option_c
    column :option_d
    column :correct_option
    actions
  end

  show title: :question do
    attributes_table do
      rows :id, :question, :option_a, :option_b, :option_c, :option_d, :correct_option
    end
  end

  filter :id
  filter :question

  form do |f|
    f.inputs do
      f.input :question, label: 'Pregunta'
      f.input :option_a, label: 'Opción A'
      f.input :option_b, label: 'Opción B'
      f.input :option_c, label: 'Opción C'
      f.input :option_d, label: 'Opción D'
      f.input :correct_option, as: :select, label: 'Opción Correcta'
    end
    f.actions
  end
end
