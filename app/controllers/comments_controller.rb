class CommentsController < ApplicationController
  before_action :load_event
  before_action :load_current_user
  
  def index
    @comments = @event.comments.includes(:user)
    render 'comments/index'
  end
  
  def create
    @comment = @current_user.comments.new(comment_params)
    if @comment.save
      render 'comments/show'
    else
      render_errors(@comment)
    end
  end
  
  def destroy
    @comment = @current_user.comments.find_by_id(params[:id])
    if @comment && @comment.destroy
      render_success
    else
      not_found("Comment")
    end
  end
  
  private
  def comment_params
    params.require(:comment).permit(:content).merge(event_id: params[:event_id])
  end

  def load_event
    @event = Event.find_by_id(params[:event_id])
    not_found("Event") unless @event
  end
end
