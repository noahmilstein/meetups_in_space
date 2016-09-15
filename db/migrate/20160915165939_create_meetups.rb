class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :location, null: false
      t.belongs_to :user, null: false
      t.datetime :time, null: false

      t.timestamps
    end
  end
end
