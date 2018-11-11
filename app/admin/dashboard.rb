ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  page_action :report, method: :post do
    redirect_to admin_dashboard_path(organization_id: params['organization_id'])
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Reporte correspondiente a', style: 'max-width: 350px; margin: auto; margin-bottom: 20px;' do
          form action: 'dashboard/report', method: :post do |f|
            f.input :authenticity_token, type: :hidden, name: :authenticity_token, value: form_authenticity_token
            table style: 'max-width: 300px;' do
              tr do
                td { f.label 'Organización: ' }
                td { f.input :organization_id, type: :string, name: 'organization_id' }
              end
              tr do
                td { f.label 'Día: ' }
                td { f.input :day, type: :string, name: 'day' }
              end
              tr do
                td { f.label 'Todos los eventos del día: ' }
                td { f.input :all, type: :checkbox, name: 'all' }
              end
              tr do
                td {}
                td { f.input :submit, type: :submit, value: 'Generar Reporte' }
              end
            end
          end
        end
        organization = params[:organization_id] || 1
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
                td Pocket.where(organization_id: organization).count
                td Pocket.where(organization_id: organization).pluck(:weight).map { |weight| weight || 0 }.sum.round
              end
              tr style: 'font-size: 150%' do
                td 'No Pesados: '
                td Pocket.where(organization_id: organization).unweighed.count
                td '-'
              end
              tr style: 'font-size: 150%' do
                td 'Pesados: '
                td Pocket.where(organization_id: organization).weighed.count
                td Pocket.where(organization_id: organization).weighed.pluck(:weight).sum.round
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
                td Bale.where(organization_id: organization).trash.count
                td Bale.where(organization_id: organization).trash.pluck(:weight).sum.round
              end
              tr style: 'font-size: 150%' do
                td 'Plástico: '
                td Bale.where(organization_id: organization).plastic.count
                td Bale.where(organization_id: organization).plastic.pluck(:weight).sum.round
              end
              tr style: 'font-size: 150%' do
                td 'Vidrio: '
                td Bale.where(organization_id: organization).glass.count
                td Bale.where(organization_id: organization).glass.pluck(:weight).sum.round
              end
            end
          end
        end
        h2 style: 'text-align: center;' do
          "Diferencia entre enfardado y pesado (Enfardado - Pesado):
            #{Bale.where(organization_id: organization).pluck(:weight).sum.round -
              Pocket.where(organization_id: organization).pluck(:weight).map { |weight| weight || 0 }.sum.round} kg"
        end
      end
    end
  end
end
