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

      let!(:bale) { create(:bale, user: auth_user) }
      let!(:second_bale) { create(:bale, user: auth_user) }
      let!(:another_bale) { create(:bale, user: another_user) }

      context 'when getting all the bales' do
        before(:each) { get :index }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return only the organization bales' do
          expect(json_response).to eql [b_serializer.new(bale).as_json, b_serializer.new(second_bale).as_json]
        end

        it 'does return the bales in order by id' do
          expect(json_response.first[:id] < json_response.second[:id])
        end

        it 'does not return bales from another organization' do
          expect(json_response.pluck(:id)).not_to include(another_bale.id)
        end
      end

      context 'when filtering by material' do
        context 'when material is valid and the are bales' do
          before(:each) { get :index, params: { material: bale.material } }

          it 'does return success' do
            expect(response).to have_http_status(:ok)
          end

          it 'does return only the organization bales' do
            expect(json_response).to eql [b_serializer.new(bale).as_json, b_serializer.new(second_bale).as_json]
          end

          it 'does not return bales from another organization' do
            expect(json_response.pluck(:id)).not_to include(another_bale.id)
          end
        end

        context 'when material is invalid' do
          before(:each) { get :index, params: { material: 'Invalid' } }

          it 'does return an error' do
            expect(response).to have_http_status(400)
          end

          it 'does return the specified error code' do
            expect(json_response[:error_code]).to eql 1
          end
        end
      end

      context 'when filtering by date' do
        context 'when the are bales in the given range' do
          let(:init_date) { Date.current - 1 }
          let(:end_date) { Date.current + 1 }
          before(:each) { get :index, params: { init_date: init_date, end_date: end_date } }

          it 'does return success' do
            expect(response).to have_http_status(:ok)
          end

          it 'does return only the organization bales' do
            expect(json_response).to eql [b_serializer.new(bale).as_json, b_serializer.new(second_bale).as_json ]
          end

          it 'does not return bales from another organization' do
            expect(json_response.pluck(:id)).not_to include(another_bale.id)
          end
        end

        context 'when the are not bales in that range' do
          let(:init_date) { Date.current + 1 }
          let(:end_date) { Date.current + 2 }
          before(:each) { get :index, params: { init_date: init_date, end_date: end_date } }

          it 'does return success' do
            expect(response).to have_http_status(:ok)
          end

          it 'does return no bales' do
            expect(json_response).to eql []
          end
        end

        context 'when a date is missing' do
          let(:end_date) { Date.current + 1 }
          before(:each) { get :index, params: { end_date: end_date } }

          it 'does return an error' do
            expect(response).to have_http_status(400)
          end

          it 'does return the specified error code' do
            expect(json_response[:error_code]).to eql 1
          end
        end

        context 'when init date happens after end date' do
          let(:init_date) { Date.current + 10 }
          let(:end_date) { Date.current + 2 }
          before(:each) { get :index, params: { init_date: init_date, end_date: end_date } }

          it 'does return success' do
            expect(response).to have_http_status(400)
          end

          it 'does return the specified error code' do
            expect(json_response[:error_code]).to eql 1
          end
        end
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
    def bale_by_id_call(bale_id)
      get :show, params: { id: bale_id }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:bale) { create(:bale, user: auth_user) }

      let!(:another_organization) { create(:organization) }
      let!(:another_user) { create(:user, organization: another_organization) }
      let!(:another_bale) { create(:bale, user: another_user) }

      context 'when showing valid bales' do
        before(:each) { bale_by_id_call(bale.id) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the serialized bale' do
          expect(json_response).to eql b_serializer.new(bale).as_json
        end
      end

      context 'when searching for unexistent bales' do
        before(:each) { bale_by_id_call(Bale.pluck(:id).max + 1) }

        it 'does return an error' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end

      context 'when searching for bales from another organization' do
        before(:each) { bale_by_id_call(another_bale.id) }

        it 'does return an error' do
          expect(response).to have_http_status(:not_found)
        end

        it 'does return the specified error code' do
          expect(json_response[:error_code]).to eql 3
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }
      let!(:bale) { create(:bale, user: user) }

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
    let(:new_weight) { Faker::Number.decimal(2, 2).to_f }
    let(:new_material) { %w[Trash Plastic Glass].sample }

    def update_bale_call(id, weight, material)
      put :update, params: { id: id, bale: { weight: weight, material: material } }
    end

    context 'when user is authenticated' do
      let!(:auth_user) { create_an_authenticated_user_with(organization, '1', 'android') }
      let!(:bale) { create(:bale, user: auth_user) }

      context 'when updating valid bales' do
        before(:each) { update_bale_call(bale.id, new_weight, new_material) }

        it 'does return success' do
          expect(response).to have_http_status(:ok)
        end

        it 'does return the right bale' do
          bale.reload
          expect(json_response).to eql b_serializer.new(bale).as_json
        end
      end

      context 'when updating an non existent bale' do
        before(:each) { update_bale_call(Bale.pluck(:id).max + 1, new_weight, new_material) }

        it 'does return not found' do
          expect(response).to have_http_status(404)
        end

        it 'does return not found' do
          expect(json_response[:error_code]).to eq 3
        end
      end

      context 'when updating invalid attributes' do
        it 'does return an error trying to change weight to nil' do
          update_bale_call(bale.id, nil, new_material)
          expect(response).to have_http_status(400)
          expect(json_response[:error_code]).to eq 1
        end

        it 'does return an error trying to change material to nil' do
          update_bale_call(bale.id, new_weight, nil)
          expect(response).to have_http_status(400)
          expect(json_response[:error_code]).to eq 1
        end
      end
    end

    context 'when user is not authenticated' do
      let!(:user) { create(:user, organization: organization) }
      let!(:bale) { create(:bale, user: user) }

      before(:each) { update_bale_call(bale.id, new_weight, new_material) }

      it 'does return an error' do
        expect(response).to have_http_status(401)
      end

      it 'does render the right error' do
        expect(json_response[:error_code]).to eql 2
      end
    end
  end
end
