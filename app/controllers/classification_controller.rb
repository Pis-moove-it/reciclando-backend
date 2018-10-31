class ClassificationController < AuthenticateController
  def create
    pockets = Pocket.where(id: classification_params[:pocket_ids], organization: logged_user.organization)
    return render_error(1, 'Negative kg of trash') if classification_params[:kg_trash].negative?
    return render_error(1, 'Negative kg of plastic') if classification_params[:kg_plastic].negative?
    return render_error(1, 'Negative kg of glass') if classification_params[:kg_glass].negative?
    return render_error(1, 'Unweighed or classified pockets') unless pockets.all?(&:Weighed?)
    pockets.each do |p|
      p.classify(pockets.sum(&:weight), classification_params[:kg_trash],
                 classification_params[:kg_plastic], classification_params[:kg_glass])
      return render_error(1, p.errors) unless p.save
    end
    render json: pockets
  end

  private

  def classification_params
    params.permit(:kg_trash, :kg_plastic, :kg_glass, pocket_ids: [])
  end
end
