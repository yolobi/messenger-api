class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.text :message
      t.integer :reply_chat_id
      t.boolean :is_read
      
      t.references :conversation, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
