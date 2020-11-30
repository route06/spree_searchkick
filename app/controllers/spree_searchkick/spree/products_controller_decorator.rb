module SpreeSearchkick::Spree::ProductsControllerDecorator
  # Sort by conversions desc
  def best_selling
    @taxon = Spree::Taxon.friendly.find(params[:id]) if params[:id]
    params.merge(taxon: @taxon.id) if @taxon
    @searcher = build_searcher(params.merge(conversions: true))
    @products = @searcher.retrieve_products
    
    render :index
  end

  # TODO: move this into an API route
  def autocomplete
    keywords = params[:keywords] ||= nil
    json = Spree::Product.autocomplete(keywords)
    render json: json
  end
end

if defined?(Spree::ProductsController)
  Spree::ProductsController.prepend(SpreeSearchkick::Spree::ProductsControllerDecorator)
end
