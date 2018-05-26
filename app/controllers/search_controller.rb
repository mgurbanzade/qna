class SearchController < ApplicationController
  skip_authorization_check

  def index
    @results = Search.query(params[:query], params[:resource])
  end
end
