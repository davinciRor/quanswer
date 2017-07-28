require 'rails_helper'

RSpec.describe AnswerCreateForSubscriberJob, type: :job do
  let!(:answer) { create(:answer) }

  it 'send email to question`s author' do
    expect(AnswerMailer).to receive(:subscribe).with(answer).and_call_original
    AnswerCreateForSubscriberJob.perform_now(answer)
  end
end
