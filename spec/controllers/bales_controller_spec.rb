require 'rails_helper'

RSpec.describe BalesController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }

  let!(:organization) { create(:organization) }
  let(:b_serializer) { BaleSerializer }

  describe 'POST #create' do
    let(:bale_params) { attributes_for(:bale) }

    def create_bale_call(weight, material)
      post :create, params: { bale: { weight: weight, material: material } }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when creating valid bales' do
        before(:each) { create_bale_call(bale_params[:weight], bale_params[:material]) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does the created bale' do
          %i[weight material].each do |bale_param|
            expect(json_response[bale_param]).to eql bale_params[bale_param]
          end
        end
      end

      context 'when creating invalid bales' do
        it 'does not create bales without material' do
          create_bale_call(bale_params[:weight], nil)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does not create bales without weight' do
          create_bale_call(nil, bale_params[:material])
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }

      before(:each) { create_bale_call(bale_params[:weight], bale_params[:material]) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'GET #index' do
    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let(:another_organization) { create(:organization) }
      let!(:another_user) { create(:user, organization: another_organization) }

      let!(:bale) { create(:bale, organization: organization, user: auth_user) }
      let!(:another_bale) { create(:bale, organization: another_organization, user: another_user) }

      before(:each) { get :index }

      it 'does return success' do
        expect(response).to have_http_status(:ok)
      end

      it 'does return only the organization bales' do
        expect(json_response).to eql [b_serializer.new(bale).as_json]
      end

      it 'does not return bales from another organization' do
        expect(json_response.pluck(:id)).not_to include(another_bale.id)
      end
    end

    context 'when user is not authenticated' do
      before(:each) { get :index }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'GET #show' do
    def bale_by_id_call(id)
      get :show, params: { id: id }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:bale) { create(:bale, organization: organization, user: auth_user) }

      context 'when shows valid bales' do
        it 'does return success' do
          bale_by_id_call(bale.id)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when shows invalid bales' do
        it 'does return not found' do
          bale_by_id_call(Bale.pluck(:id).max + 1)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }
      let!(:bale) { create(:bale, organization: organization, user: user) }

      before(:each) { bale_by_id_call(bale.id) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'PUT #update' do
    def update_bale_call(id, weight, material)
      put :update, params: { id: id, bale: { weight: weight, material: material } }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:bale) { create(:bale, organization: organization, user: auth_user) }

      context 'when updating valid bales' do
        before(:each) { update_bale_call(bale.id, bale.weight, bale.material) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the right bale' do
          expect(json_response).to eql b_serializer.new(bale).as_json
        end
      end

      context 'when updating an non existent bale' do
        before(:each) { update_bale_call(Bale.pluck(:id).max + 1, bale.weight, bale.material) }

        it 'does return not found' do
          expect(response).to have_http_status(404)
        end

        it 'does return not found' do
          expect(json_response[:error_code]).to eq 3
        end
      end

      context 'when updating invalid attributes' do
        it 'does return an error trying to change weight to nil' do
          update_bale_call(bale.id, nil, %w[Trash Plastic Glass].sample)
          expect(response).to have_http_status(400)
          expect(json_response[:error_code]).to eq 1
        end

        it 'does return an error trying to change material to nil' do
          update_bale_call(bale.id, bale.weight, nil)
          expect(response).to have_http_status(400)
          expect(json_response[:error_code]).to eq 1
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }
      let!(:bale) { create(:bale, organization: organization, user: user) }

      before(:each) { update_bale_call(bale.id, bale.weight, bale.material) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'GET #show_by_material' do
    def show_bales_by_material_call(material)
      get :show_by_material, params: { material: material }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }

      context 'when material is valid' do
        let(:material) { %w[Plastic Trash Glass].sample }
        let!(:bale) { create(:bale, organization: organization, user: auth_user, material: material) }

        before(:each) { show_bales_by_material_call(material) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the bales' do
          expect(json_response.count).to eql 1
        end

        it 'does return the bales as expected in the serializer' do
          expect(json_response).to eql [b_serializer.new(bale).as_json]
        end
      end

      context 'when material is incorrect or missing' do
        let!(:bale) do
          create(:bale, organization: organization, user: auth_user,
                        material: %w[Plastic Trash Glass].sample)
        end

        after(:each) do
          expect(response).to have_http_status(:bad_request)
          expect(json_response[:error_code]).to eql 1
          expect(json_response[:details]).to eql 'Material must be: "Trash", "Glass" or "Plastic".'
        end

        it 'does return an error when material is invalid' do
          show_bales_by_material_call('invalid string')
        end

        it 'does return an error when material is nil' do
          show_bales_by_material_call(nil)
        end
      end

      context 'when bales are from another orgzanization' do
        let!(:another_organization) { create(:organization) }
        let(:material) { %w[Plastic Trash Glass].sample }
        let!(:bale) do
          create(:bale, organization: another_organization, user: auth_user,
                        material: material)
        end

        before(:each) { show_bales_by_material_call(material) }

        it 'does return success' do
          expect(response).to have_http_status(200)
        end

        it 'does not return bales from another organization' do
          expect(json_response.count).to eql 0
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }

      before(:each) { show_bales_by_material_call(%w[Plastic Trash Glass].sample) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end

  describe 'GET #show_by_date' do
    let(:init_date) { Date.current - 1 }
    let(:end_date) { Date.current + 1 }
    def show_bales_by_date_call(init_date, end_date)
      get :show_by_date, params: { init_date: init_date, end_date: end_date }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let(:material) { %w[Plastic Trash Glass].sample }
      let!(:bale) { create(:bale, organization: organization, user: auth_user, material: material) }

      context 'when the range date is valid and there are bales in that range' do
        before(:each) { show_bales_by_date_call(init_date, end_date) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the bales' do
          expect(json_response.count).to eql 1
        end

        it 'does return the bales as expected in the serializer' do
          expect(json_response).to eql [b_serializer.new(bale).as_json]
        end

        context 'when the initial date its the same that the end date' do
          it 'does return success' do
            show_bales_by_date_call(Date.current, Date.current)
            expect(response).to have_http_status(:ok)
          end

          it 'does return the bales' do
            expect(json_response.count).to eql 1
          end
        end
      end

      context 'when the range date is valid and there are no bales in that range' do
        let(:valid_init) { Date.current + 28 }
        let(:valid_end) { Date.current + 30 }

        before(:each) { show_bales_by_date_call(valid_init, valid_end) }

        it 'does return succes' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return an empty list' do
          expect(json_response.count).to eql 0
        end
      end

      context 'when the range date is missing' do
        it 'does return bad request' do
          show_bales_by_date_call(nil, end_date)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does return the right error' do
          show_bales_by_date_call(nil, end_date)
          expect(json_response[:error_code]).to eql 1
        end

        it 'does return initial date missing' do
          show_bales_by_date_call(nil, end_date)
          expect(json_response[:details]).to eql 'Initial date missing'
        end

        it 'does return bad request' do
          show_bales_by_date_call(init_date, nil)
          expect(response).to have_http_status(:bad_request)
        end

        it 'does return the right error' do
          show_bales_by_date_call(init_date, nil)
          expect(json_response[:error_code]).to eql 1
        end

        it 'does return end date missing' do
          show_bales_by_date_call(init_date, nil)
          expect(json_response[:details]).to eql 'End date missing'
        end
      end

      context 'when the range date is invalid' do
        let(:invalid_init_date) { Date.current + 1 }
        let(:invalid_end_date) { Date.current + -1 }

        before(:each) { show_bales_by_date_call(invalid_init_date, invalid_end_date) }

        it 'does return bad request' do
          expect(response).to have_http_status(:bad_request)
        end

        it 'does return the right error' do
          expect(json_response[:error_code]).to eql 1
        end
      end

      context 'when there are bales for the range date but there are from another organization' do
        let!(:another_organization) { create(:organization) }
        let(:material) { %w[Plastic Trash Glass].sample }
        let!(:bale) do
          create(:bale, organization: another_organization, user: auth_user,
                        material: material)
        end

        before(:each) { show_bales_by_date_call(init_date, end_date) }

        it 'does return succes' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return an empty list' do
          expect(json_response.count).to eql 0
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }

      before(:each) { show_bales_by_date_call(init_date, end_date) }

      it 'does return unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
