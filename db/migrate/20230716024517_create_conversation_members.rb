class CreateConversationMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :conversation_members do |t|
      t.references :conversation, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
