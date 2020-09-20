class AddStaleToTranslations < ActiveRecord::Migration[6.0]
  def change
    add_column :translation_manager_translations, :stale, :boolean, default: false, null: false
  end
end
