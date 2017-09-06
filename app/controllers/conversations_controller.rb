class ConversationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:contact_support]
  def new
  end

  def create
    body = conversation_params[:body]

    body = add_project_link_to_body(body, params[:conversation][:project_id])  if params[:conversation][:project_id]

    body = add_student_link_to_body(body, params[:conversation][:user_id]) if params[:conversation][:user_id]


    recipients = User.where(id: conversation_params[:recipients])
    conversation = current_user.send_message(recipients,
                                             body,
                                             conversation_params[:subject]
    ).conversation
    flash[:success] = "Your message was successfully sent!"
    redirect_to conversation_path(conversation)
  end

  def show
    @receipts = conversation.receipts_for(current_user)
    # mark conversation as read
    conversation.mark_as_read(current_user)
  end

  def reply
    current_user.reply_to_conversation(conversation, message_params[:body])
    flash[:notice] = "Your reply message was successfully sent!"
    redirect_to conversation_path(conversation)
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to mailbox_inbox_path
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to mailbox_inbox_path
  end

  # GET /apply
  def apply
    if params[:p_id].present?
      project = Project.find(params[:p_id])
      save_interested_students project
      @applied_project = project
      @recipient = project.user
    else
      redirect_to root_path
    end
  end

  def accept_student
    if params[:p_id] && params[:u_id]
      @recipient = User.find(params[:u_id])
      @project = Project.find(params[:p_id])
    else
      redirect_to root_path
    end
  end

  def contact_support
    @support = User.where(email: 'isagonzacr@gmail.com').first
  end

  private

  def conversation_params
    params.require(:conversation).permit(:subject, :body, recipients:[])
  end

  def message_params
    params.require(:message).permit(:body, :subject)
  end

  def save_interested_students project
    project.interested_students ||= []
    project.interested_students << current_user.id
    project.interested_students.uniq!
    project.save
  end

  def add_project_link_to_body(body, p_id)
    "#{body}.
    If you are interested please
    <a href='/accept_project?p_id=#{p_id}'>follow this link</a>"
  end

  def add_student_link_to_body(body, u_id)
    p_id = params[:conversation][:applied_project_id]
    "#{body}.
    You can access the student profile
    <a href='#{user_path(u_id: u_id, p_id: p_id)}'>following this link</a>"
  end
end
