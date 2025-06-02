class AddCourseToEnrollments < ActiveRecord::Migration[7.2]
  def change
    add_reference :enrollments, :course, null: false, foreign_key: true
  end
end
