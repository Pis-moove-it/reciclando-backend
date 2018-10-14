require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:json_response) { JSON.parse(response.body, symbolize_names: true) }
  let(:serializer) { QuestionSerializer }

  describe 'GET #index' do
    def questions_call
      get :index
    end

    before(:each) do
      create_list(:question, 10)
      questions_call
    end

    it 'does return success' do
      expect(response).to have_http_status(200)
    end

    it 'does return only six questions' do
      expect(json_response.count).to eql 6
    end

    it 'does return questions as exepcted in the serializer' do
      expect(json_response.first).to eql serializer.new(Question.find(json_response.first[:id])).as_json
    end
  end
end
