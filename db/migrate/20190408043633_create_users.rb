class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, index: true, foreign_key: true
      t.string :email, index: true, foreign_key: true
      t.string :password
      t.timestamps
    end
  end
end
