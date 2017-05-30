class AttachmentsController < ApplicationController
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy if current_user.author_of?(@attachment.attachable)
    flash[:notice] = 'Success destroyed.'
    case @attachment.attachable_type
    when 'Question'
      redirect_to question_path(@attachment.attachable)
    when 'Answer'
      redirect_to question_path(@attachment.attachable.question)
    end
  end
end
