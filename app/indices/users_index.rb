ThinkingSphinx::Index.define :user, with: :active_record do
  #fields
  indexes email, sortable: true
  indexes reputation

  #attributes
  has created_at, updated_at
end