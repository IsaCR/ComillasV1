json.extract! project, :id, :title, :description, :in_progress, :user_id, :created_at, :updated_at, :student_id, :interested_students
json.url project_url(project, format: :json)
