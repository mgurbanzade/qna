ThinkingSphinx::Index.define :comment, with: :active_record do
  #fileds
  indexes body, as: :comment_body, sortable: true
  indexes user.email, as: :author, sortable: true

  #attributes
  has commentable_id, user_id, created_at, updated_at
end
