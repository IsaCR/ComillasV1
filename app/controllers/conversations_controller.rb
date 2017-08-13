class ConversationsController < ApplicationController
  def new
  end

  def create
    body = conversation_params[:body]

    if params[:project_id]
      body = add_link_to_body(body, params[:project_id])
    end

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

  def add_link_to_body(body, p_id)
    "#{body}.
    If you are interested please
    <a href='/accept_project?p_id=#{p_id}'>follow this link</a>"
  end
end
