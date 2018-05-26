class Search
  RESOURCES = %w(All Users Questions Answers Comments)

  def self.query(query, resource)
    return [] unless RESOURCES.include?(resource)
    escaped_query = Riddle::Query.escape(query)
    return ThinkingSphinx.search escaped_query if resource == 'All'
    ThinkingSphinx.search escaped_query, classes: [resource.singularize.classify.constantize]
  end
end
