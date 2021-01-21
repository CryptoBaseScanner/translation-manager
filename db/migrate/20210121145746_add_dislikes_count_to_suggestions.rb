class AddDislikesCountToSuggestions < ActiveRecord::Migration[6.0]
  def change
    add_column :translation_manager_suggestions, :dislikes_count, :integer, after: :approvals_count, default: 0
    add_column :translation_manager_suggestions, :vote_sum, :integer, after: :dislikes_count, default: 0
  end
end
