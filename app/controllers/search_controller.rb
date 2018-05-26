class SearchController < ApplicationController
  skip_authorization_check

  def index
    @results = ThinkingSphinx.search(@query)
  end
end
