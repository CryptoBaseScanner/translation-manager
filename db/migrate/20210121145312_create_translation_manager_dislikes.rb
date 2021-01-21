class CreateTranslationManagerDislikes < ActiveRecord::Migration[6.0]
  def change
    create_table :translation_manager_dislikes do |t|
      t.references :translation_manager_suggestion,
                   null: false,
                   foreign_key: true,
                   index: { name: 'suggestion_dislike' }
      t.integer :disliked_by

      t.timestamps
    end
  end
end
