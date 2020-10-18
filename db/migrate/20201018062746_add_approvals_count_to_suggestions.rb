class AddApprovalsCountToSuggestions < ActiveRecord::Migration[6.0]
  def change
    add_column :translation_manager_suggestions, :approvals_count, :integer
  end
end
