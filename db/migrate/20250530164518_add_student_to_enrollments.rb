class AddStudentToEnrollments < ActiveRecord::Migration[7.2]
  def change
    add_reference :enrollments, :student, null: false, foreign_key: true
  end
end
