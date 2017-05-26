class AddQuestionIdToAttachment < ActiveRecord::Migration[5.1]
  def change
    add_column :attachments, :question_id, :integer, index: true
  end
end
