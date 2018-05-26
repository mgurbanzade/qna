module SearchHelper
  def resource(result)
    return result if result.is_a?(Question)
    result.question
  end
end
