class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    if current_user.is_student?
      @projects = order_projects.map { |k| k[:project] }
    else
      @projects = projects_by_type(params[:type])
    end
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

  def conclude_project
    project = current_user.projects.find(params[:p_id])
    project.in_progress = false
    project.save

    if project.portfolio.nil?
      Portfolio.create(title: project.title,
                       description: project.description,
                       user_id: project.student_id,
                       project_id: project.id
      )
    end

    redirect_to projects_path(type: 'finished')
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


  def projects_by_type(type)
    case type
    when 'available'
      current_user.projects.where(in_progress: nil, student_id: nil)
    when 'current'
      current_user.projects.where(in_progress: true).where.not(student_id: nil)
    when 'finished'
      current_user.projects.where(in_progress: false).where.not(student_id: nil)
    else
      current_user.projects
    end
  end
end
