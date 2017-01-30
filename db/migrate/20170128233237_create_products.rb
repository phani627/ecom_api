class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|

      t.string  :description, null: false
      t.string  :name, null: false
      t.float   :price, null: false

      t.timestamps null: false
    end
  end
end
