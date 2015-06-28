class CreatePrimeros < ActiveRecord::Migration
  def change
    create_table :primeros do |t|
      t.string :cadena
      t.string :resultado

      t.timestamps null: false
    end
  end
end
