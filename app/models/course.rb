class Course < ApplicationRecord

  has_many :enrollments
  has_many :courses, through: :enrollments
end
