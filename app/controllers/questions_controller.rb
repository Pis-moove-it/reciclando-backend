class QuestionsController < BaseController
  def index
    render json: Question.all.sample(6)
  end
end
