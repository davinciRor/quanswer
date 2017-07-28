class SearchService
  SEARCH_LIST = %w(Answer Question Comment User)

  class << self
    def search(text, model)
      if model && SEARCH_LIST.include?(model)
        model.constantize.search(convert_text_for_search(text))
      else
        ThinkingSphinx.search(convert_text_for_search(text))
      end
    end

    private

    def convert_text_for_search(text)
      text.sub('@', '\@')
    end
  end
end