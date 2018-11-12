ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  page_action :report, method: :post do
    redirect_to admin_dashboard_path(organization_id: params['organization_id'],
                                     all: params['all'],
                                     date: params['date'])
  end

  content title: proc { I18n.t('active_admin.dashboard') } do
    # Use organization_id param to filter pockets and bales
    organization_id = params[:organization_id] || 1

    # Use current time if date param is not present
    # If date param is present, change it to a time object in UTC
    date = if params[:date]
             params[:date].to_time(:utc)
           else
             Time.current
           end

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
              current_time = Time.current.strftime('%Y/%m/%d').gsub(/\//, '-')
              time = params[:date] || current_time
              tr do
                td { f.label 'Día (mm/dd/YY): ' }
                td { f.input :date, type: :date, name: 'date', value: time, max: current_time }
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
            pocket_query = Pocket.where(organization_id: organization_id,
                                        created_at: date.beginning_of_day..date.end_of_day)
            tbody do
              tr style: 'font-size: 150%' do
                td 'Totales: '
                td pocket_query.count
                td pocket_query.pluck(:weight).map { |weight| weight || 0 }.sum.round
              end
              tr style: 'font-size: 150%' do
                td 'No Pesados: '
                td pocket_query.unweighed.count
                td '-'
              end
              tr style: 'font-size: 150%' do
                td 'Pesados: '
                td pocket_query.weighed.count
                td pocket_query.weighed.pluck(:weight).sum.round
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
              bale_query = Bale.where(organization_id: organization_id,
                                      created_at: date.beginning_of_day..date.end_of_day)
              tbody do
                tr style: 'font-size: 150%' do
                  td 'Basura: '
                  td bale_query.trash.count
                  td bale_query.trash.pluck(:weight).sum.round
                end
                tr style: 'font-size: 150%' do
                  td 'Plástico: '
                  td bale_query.plastic.count
                  td bale_query.plastic.pluck(:weight).sum.round
                end
                tr style: 'font-size: 150%' do
                  td 'Vidrio: '
                  td bale_query.glass.count
                  td bale_query.glass.pluck(:weight).sum.round
                end
              end
            end
          end
          h2 style: 'text-align: center;' do
            "Diferencia entre enfardado y pesado (Enfardado - Pesado):
              #{bale_query.pluck(:weight).sum.round -
                pocket_query.pluck(:weight).map { |weight| weight || 0 }.sum.round} kg"
          end
        end
      end
    end
  end
end
