ActiveAdmin.register_page 'Test' do
  page_action :foo, method: :get do
    # do some logic using params['my_field']
    redirect_to "/admin/test", test: params['my_field']
  end

  content do
    form action: "test/foo", method: :get do |f|
      f.input :authenticity_token, type: :hidden, name: :authenticity_token, value: form_authenticity_token
      f.input :my_field, type: :text, name: 'my_field'
      f.input :submit, type: :submit
    end
    h2 do
      byebug
      "hola #{params[:test]}"
    end
  end
end
