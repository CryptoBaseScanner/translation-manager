class CreateImport < ActiveRecord::Migration[6.0]
  def change
    create_table :translation_manager_imports do |t|
      t.string :status, null: false, default: 'processing'
      t.string :namespace

      t.timestamps
    end
  end
end
