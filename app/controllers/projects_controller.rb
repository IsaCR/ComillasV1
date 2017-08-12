class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    if current_user.is_student?
      @projects = order_projects.map { |k| k[:project] }
    else
      @projects = Project.where(user_id: current_user.id)
    end
    render :index
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def accept_project
    project = Project.find(params[:p_id])
    if current_user.is_student && (project.user != current_user)
      project.student_id = current_user.id
      project.in_progress = true
      project.save
    end
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title,
                                      :description,
                                      :in_progress,
                                      :user_id,
                                      :image,
                                      :student_id,
                                      :interested_students,
                                      skill_ids: []
      )
    end

  def active_projects
    Project.where(in_progress: nil, student_id: nil)
  end

  def order_projects
    order_projects = []
    active_projects.each do |project|
      matching_skills = (project.skills & current_user.skills).count
      order_projects << {
        matching_porcentage: matching_skills * 100 / project.skills.count,
        project: project
      }
    end
    order_projects.sort_by! { |k| k[:matching_porcentage] * -1}
  end
end
