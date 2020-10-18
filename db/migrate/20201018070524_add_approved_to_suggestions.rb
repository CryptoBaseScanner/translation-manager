class AddApprovedToSuggestions < ActiveRecord::Migration[6.0]
  def change
    add_column :translation_manager_suggestions, :approved, :boolean
  end
end
