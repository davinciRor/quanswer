require 'rails_helper'

describe SearchService do
  it 'should receive search for User' do
    expect(User).to receive(:search)
    SearchService.search('text', 'User')
  end

  it 'should receive search for Question' do
    expect(Question).to receive(:search)
    SearchService.search('text', 'Question')
  end

  it 'should receive search for Comment' do
    expect(Comment).to receive(:search)
    SearchService.search('text', 'Comment')
  end

  it 'should receive search for Answer' do
    expect(Answer).to receive(:search)
    SearchService.search('text', 'Answer')
  end

  it 'should receive search for ALL' do
    expect(ThinkingSphinx).to receive(:search)
    SearchService.search('text', nil)
  end
end