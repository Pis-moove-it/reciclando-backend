ActiveAdmin.register_page 'Collection Points Map' do
  content do
    active_picture = asset_path('map-point-icon.png')
    inactive_picture = asset_path('map-point-icon-red.png')

    hash = Gmaps4rails.build_markers(CollectionPoint.all) do |collection_point, marker|
      marker.lat collection_point.latitude
      marker.lng collection_point.longitude

      picture = inactive_picture
      picture = active_picture if collection_point.active
      marker.picture url: picture, width: 50, height: 50

      marker.infowindow "<table>
        <tr><td><b>ID: #{collection_point.id}</b></td></tr>
        <tr><td><form html='{:multipart=>true}' onsubmit='return submitMarker();'action='/collection_points' accept-charset='UTF-8'
        data-remote='true' method='put'><select name='active' id='active'><option selected='' value='true'>Activo</option><option value='false'>Inactivo</option>
        </select><input type='hidden' name='latitude' id='lat' value=#{collection_point.latitude}><input type='hidden' name='longitude' id='lng' value=#{collection_point.longitude}>
        <input type='submit' name='commit' value='Actualizar' data-disable-with='Actualizar'>
        <input type='hidden' name='latitude' id='lat' value=#{collection_point.latitude}><input type='hidden' name='longitude' id='lng' value=#{collection_point.longitude}>
        </td></form><td></td></tr>
        <tr><td><form html='{:multipart=>true}' onsubmit='return submitMarker();'action='/collection_points' accept-charset='UTF-8' data-remote='true' method='delete'>
        <input type='hidden' name='latitude' id='lat' value=#{collection_point.latitude}><input type='hidden' name='longitude' id='lng' value=#{collection_point.longitude}>
        <input type='submit' name='commit' value='Borrar Punto de Recolección' data-disable-with='Borrar Punto de Recolección'></form>
        </td></tr></table>"
    end

    render partial: 'map', locals: { markers: hash }
  end
end
