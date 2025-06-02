class CreateEnrollments < ActiveRecord::Migration[7.2]
  def change
    create_table :enrollments do |t|
      t.string :created_by

      t.timestamps
    end
  end
end
