ActiveAdmin.register_page 'Mapa de Islas' do
  menu priority: 9

  page_action :create, method: :post do
    container_params = {
      latitude: params[:latitude],
      longitude: params[:longitude],
      organization_id: params[:organization_id]
    }

    Container.create(container_params)

    respond_to do |format|
      format.js { render inline: 'location.reload();' }
    end
  end

  page_action :update, method: :put do
    container = Container.find_by(latitude: params[:latitude],
                                  longitude: params[:longitude])

    container.update(active: params[:active])

    respond_to do |format|
      format.js { render inline: 'location.reload();' }
    end
  end

  page_action :destroy, method: :delete do
    container = Container.find_by(latitude: params[:latitude],
                                  longitude: params[:longitude])

    container.destroy

    respond_to do |format|
      format.js { render inline: 'location.reload();' }
    end
  end

  content do
    active_picture = asset_path('map-point-icon.png')
    inactive_picture = asset_path('map-point-icon-red.png')

    hash = Gmaps4rails.build_markers(CollectionPoint.all) do |container, marker|
      marker.lat container.latitude
      marker.lng container.longitude

      picture = inactive_picture
      picture = active_picture if container.active
      marker.picture url: picture, width: 50, height: 50

      marker.infowindow "<table>
        <tr><td><b>ID: #{container.id}</b></td></tr>
        <tr><td><b>Organización ID: #{container.organization_id}</b></td></tr>
        <tr><td><form html='{:multipart=>true}' action='/admin/mapa_de_islas/update'
        accept-charset='UTF-8' data-remote='true' method='put'>
        <select name='active' id='active'>
        <option selected='' value='true'>Activo</option><option value='false'>Inactivo</option>
        </select>
        <input type='hidden' name='authenticity_token' id='authenticity_token' value=#{form_authenticity_token}>
        <input type='hidden' name='latitude' id='lat' value=#{container.latitude}>
        <input type='hidden' name='longitude' id='lng' value=#{container.longitude}>
        <input type='submit' name='commit' value='Actualizar' data-disable-with='Actualizar'>
        </td></form><td></td></tr>
        <tr><td>
        <form html='{:multipart=>true}' action='/admin/mapa_de_islas/destroy'
        accept-charset='UTF-8' data-remote='true' method='delete'>
        <input type='hidden' name='authenticity_token' id='authenticity_token' value=#{form_authenticity_token}>
        <input type='hidden' name='latitude' id='lat' value=#{container.latitude}>
        <input type='hidden' name='longitude' id='lng' value=#{container.longitude}>
        <input type='submit' name='commit' value='Eliminar' data-disable-with='Eliminar'></form>
        </td></tr></table>"
    end

    render partial: 'map', locals: { markers: hash }
  end
end
