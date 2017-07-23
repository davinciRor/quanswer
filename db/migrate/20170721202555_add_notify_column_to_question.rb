class AddNotifyColumnToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :notify_author, :boolean, default: true
  end
end
