class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]
  before_action :fetch_courses, only: %i[create new edit update]
  before_action :fetch_students, only: %i[create new edit update]

  # GET /enrollments or /enrollments.json
  def index
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments or /enrollments.json
  def create

    @enrollments = params.dig(:enrollment, :course_id).compact_blank.map do |course_id|
      Enrollment.create!(enrollment_params.merge(course_id:))
    end

    respond_to do |format|
      if @enrollments.all?(&:persisted?)
        format.html { redirect_to enrollments_path, notice: "Enrollments were successfully created." }
        format.json { render :show, status: :created, location: @enrollments }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollments.map(&:errors), status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    @enrollment.destroy!

    respond_to do |format|
      format.html { redirect_to enrollments_path, status: :see_other, notice: "Enrollment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def report
    @enrollments = Enrollment.includes(:student, :course).order('students.name')

    respond_to do |format|
      format.pdf do
        pdf = EnrollmentReport.new(@enrollments)
        send_data pdf.render,
                  filename: "relatorio_matriculas.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:created_by, :student_id)
    end

    def fetch_students
      @students = Student.all
    end

    def fetch_courses
      @courses = Course.all
    end
end
