class AttachmentsController < ApplicationController
  before_action :set_attachment

  authorize_resource

  def destroy
    @attachment.destroy
    flash[:notice] = 'Success destroyed.'
    case @attachment.attachable_type
    when 'Question'
      redirect_to question_path(@attachment.attachable)
    when 'Answer'
      redirect_to question_path(@attachment.attachable.question)
    end
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
