require "prawn"
require "prawn/table"

class EnrollmentReport < Prawn::Document
  def initialize(enrollments)
    super(top_margin: 50)
    @enrollments = enrollments
    title
    table_content
  end

  def title
    text "Relatório de Matrículas", size: 24, style: :bold, align: :center
    move_down 20
  end

  def table_content
    table enrollment_rows do
      row(0).font_style = :bold
      self.header = true
    end
  end

  def enrollment_rows
    [["ID", "Aluno", "Curso", "Criado por", "Data da Matrícula"]] +
      @enrollments.map do |enrollment|
        [
          enrollment.id,
          enrollment.student.name,
          enrollment.course.name,
          enrollment.created_by,
          enrollment.created_at.strftime("%d/%m/%Y")
        ]
      end
  end
end
