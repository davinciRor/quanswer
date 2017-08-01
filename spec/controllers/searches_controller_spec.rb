require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #new' do
    before { get :new }

    it 'assign search list' do
      expect(assigns(:search_list)).to eq %w(Answer Question Comment User)
    end
  end

  describe 'GET #start' do
    it 'use SearchService service' do
      expect(SearchService).to receive(:search).with('Text', 'Answer')
      get :start, params: { text: 'Text', model: 'Answer' }
    end
  end
end
