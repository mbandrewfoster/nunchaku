class Nunchaku::ResourcesController < Nunchaku::ApplicationController
  include Nunchaku::Resources

  AUTOCOMPLETE_LIMIT = 50

  around_filter :transactions_filter, :only => %w(create update)

	helper_method :collection_fields, :decorator_context

  def autocomplete
    respond_with autocomplete_collection.limit(AUTOCOMPLETE_LIMIT).map { |a| {:id => a.id, :text => a.to_s } }
  end

  protected

  def resource_params
    params.require(resource_params_name) \
      .permit(permitted_params)
  end

  def permitted_params
    []
  end

  def transactions_filter
    ActiveRecord::Base.transaction do
      yield
    end
  end

  def collection_fields
    []
  end

  def decorator_context
    nil
  end

  def autocomplete_collection
    collection_translated_or_else_fuzzy
  end

  def collection_translated_or_else_fuzzy
    collection.send (collection.respond_to?(:translated_search) ? :translated_search : :fuzzy_search), search_terms
  end
end

