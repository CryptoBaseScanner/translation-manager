class AddFileToImport < ActiveRecord::Migration[6.0]
  def change
    add_column :translation_manager_imports, :file, :text, limit: 5.megabyte
  end
end
