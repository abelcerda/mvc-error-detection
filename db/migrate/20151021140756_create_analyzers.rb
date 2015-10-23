class CreateAnalyzers < ActiveRecord::Migration
  def change
    create_table :analyzers do |t|
      t.string :directory
      t.string :lenguage

      t.timestamps null: false
    end
  end
end
