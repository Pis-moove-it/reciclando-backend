class ClassificationController < AuthenticateController
  def create
    return render_error(1, 'Unweighed or classified pockets') unless pockets.all?(&:Weighed?)
    pockets.each do |p|
      p.classify(pockets.sum(&:weight), classification_params[:kg_trash],
                 classification_params[:kg_plastic], classification_params[:kg_glass])
      return render_error(1, p.errors) unless p.save
    end
    render json: pockets
  end

  private

  def pockets
    @pockets ||= Pocket.where(id: classification_params[:pocket_ids], organization: logged_user.organization)
  end

  def classification_params
    params.permit(:kg_trash, :kg_plastic, :kg_glass, pocket_ids: [])
  end
end
