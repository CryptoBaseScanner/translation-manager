class CreateTranslationManagerSuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :translation_manager_suggestions do |t|
      t.string :suggestion
      t.references :translation_manager_translation,
                   null: false,
                   foreign_key: true,
                   index: { name: 'suggestion_translation' }
      t.integer :translator_id

      t.timestamps
    end
  end
end
