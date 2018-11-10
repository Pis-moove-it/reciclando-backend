ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Bolsones' do
          table do
            thead do
              tr do
                th ''
                th :Cantidad
                th :Peso
              end
            end
            tbody do
              tr style: 'font-size: 150%' do
                td 'Totales: '
                td Pocket.count
                td Pocket.pluck(:weight).map { |weight| weight || 0 }.sum.round
              end
              tr style: 'font-size: 150%' do
                td 'No Pesados: '
                td Pocket.unweighed.count
                td '-'
              end
              tr style: 'font-size: 150%' do
                td 'Pesados: '
                td Pocket.weighed.count
                td Pocket.weighed.pluck(:weight).sum.round
              end
            end
          end
        end
        panel 'Fardos' do
          table do
            thead do
              tr do
                th ''
                th :Cantidad
                th :Peso
              end
            end
            tbody do
              tr style: 'font-size: 150%' do
                td 'Basura: '
                td Bale.trash.count
                td Bale.trash.pluck(:weight).sum.round
              end
              tr style: 'font-size: 150%' do
                td 'Plástico: '
                td Bale.plastic.count
                td Bale.plastic.pluck(:weight).sum.round
              end
              tr style: 'font-size: 150%' do
                td 'Vidrio: '
                td Bale.glass.count
                td Bale.glass.pluck(:weight).sum.round
              end
            end
          end
        end
        h2 style: 'text-align: center;' do
          "Diferencia entre enfardado y pesado (Enfardado - Pesado):
            #{Bale.pluck(:weight).sum.round - Pocket.pluck(:weight).map { |weight| weight || 0 }.sum.round} kg"
        end
      end
    end
  end
end
