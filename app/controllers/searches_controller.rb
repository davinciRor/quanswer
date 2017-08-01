class SearchesController < ApplicationController
  skip_authorization_check

  def new
    @search_list = SearchService::SEARCH_LIST
  end

  def start
    @items = SearchService.search(params[:text], params[:model])
  end

  private
end
