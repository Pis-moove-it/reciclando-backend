ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  page_action :report, method: :post do
    redirect_to admin_dashboard_path(organization_id: params['organization_id'], all: params['all'])
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Use organization_id param to filter pockets and bales
    organization_id = params[:organization_id] || 1

    columns do
      column do
        panel 'Reporte correspondiente a', style: 'max-width: 350px; margin: auto; margin-bottom: 20px;' do
          form action: admin_dashboard_report_path, method: :post do |f|
            f.input :authenticity_token, type: :hidden, name: :authenticity_token, value: form_authenticity_token
            table style: 'max-width: 300px;' do
              tr do
                td { f.label 'Organización: ' }
                td do
                  select name: 'organization_id' do
                    Organization.all.each do |organization|
                      option value: organization.id, selected: organization_id.eql?(organization.id.to_s) do
                        organization.name
                      end
                    end
                  end
                end
              end
              tr do
                td { f.label 'Día: ' }
                td { f.input :day, type: :string, name: 'day' }
              end
              tr do
                td { f.label 'Todos los eventos del día: ' }
                td { f.input :all, type: :checkbox, name: 'all', checked: params[:all] }
              end
              tr do
                td {}
                td { f.input :submit, type: :submit, value: 'Generar Reporte' }
              end
            end
          end
        end

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
                td Pocket.where(organization_id: organization_id).count
                td Pocket.where(organization_id: organization_id).pluck(:weight).map { |weight| weight || 0 }.sum.round
              end
              tr style: 'font-size: 150%' do
                td 'No Pesados: '
                td Pocket.where(organization_id: organization_id).unweighed.count
                td '-'
              end
              tr style: 'font-size: 150%' do
                td 'Pesados: '
                td Pocket.where(organization_id: organization_id).weighed.count
                td Pocket.where(organization_id: organization_id).weighed.pluck(:weight).sum.round
              end
            end
          end
        end

        # Show this panel only if checkbox is checked
        if params[:all]
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
                  td Bale.where(organization_id: organization_id).trash.count
                  td Bale.where(organization_id: organization_id).trash.pluck(:weight).sum.round
                end
                tr style: 'font-size: 150%' do
                  td 'Plástico: '
                  td Bale.where(organization_id: organization_id).plastic.count
                  td Bale.where(organization_id: organization_id).plastic.pluck(:weight).sum.round
                end
                tr style: 'font-size: 150%' do
                  td 'Vidrio: '
                  td Bale.where(organization_id: organization_id).glass.count
                  td Bale.where(organization_id: organization_id).glass.pluck(:weight).sum.round
                end
              end
            end
          end
          h2 style: 'text-align: center;' do
            "Diferencia entre enfardado y pesado (Enfardado - Pesado):
              #{Bale.where(organization_id: organization_id).pluck(:weight).sum.round -
                Pocket.where(organization_id: organization_id).pluck(:weight)
                .map { |weight| weight || 0 }.sum.round} kg"
          end
        end
      end
    end
  end
end
