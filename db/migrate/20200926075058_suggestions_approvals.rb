class SuggestionsApprovals < ActiveRecord::Migration[6.0]
  def change
    create_table :translation_manager_approvals do |t|
      t.references :translation_manager_suggestion,
                   null: false,
                   foreign_key: true,
                   index: { name: 'suggestion_approval' }
      t.integer :approved_by

      t.timestamps
    end

  end
end
