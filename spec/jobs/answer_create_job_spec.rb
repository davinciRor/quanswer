require 'rails_helper'

RSpec.describe AnswerCreateJob, type: :job do
  let!(:answer) { create(:answer) }

  it 'send email to question`s author' do
    expect(AnswerMailer).to receive(:create).with(answer).and_call_original
    AnswerCreateJob.perform_now(answer)
  end
end
