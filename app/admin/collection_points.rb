ActiveAdmin.register_page 'CollectionPoints' do
  content do
    hash = Gmaps4rails.build_markers(CollectionPoint.all) do |collection_point, marker|
      marker.lat collection_point.latitude
      marker.lng collection_point.longitude
      marker.picture url: asset_path('map-point-icon.png'), width: 50, height: 50
    end
    render partial: 'map', locals: { markers: hash }
  end
end
