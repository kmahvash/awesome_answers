class AnswersController < ApplicationController

  before_action :authenticate_user

  def create
    answer_params = params.require(:answer).permit(:body)
    # params[:question_id] is coming from the URL which looks like /questions/98/answers
    @q = Question.find params[:question_id]
    @answer = current_user.answers.new(answer_params)
    @answer.question = @q
    if @answer.save
    # you can check to see if it is created in console by Answer.last OR canc heck the server log which shoudl ahve commit in it if it has been successfullys added.
      redirect_to question_path(@q), notice: "Answer created successfully."
    else
      # youc an show the arror message as a flash (already included in layout) by:
      # flash[:alert] = @answer.errors.full_messages.join(" AND/OR ")
    # you sue render because you want the apge to include the data already entered.
      render "questions/show"
    # to see the params as being submitted by form:
#   render text: params
    end
  end

  def destroy
    answer = Answer.find params[:id]
    redirect_to root_path, alert: "Access denied!" unless can?(:destroy, answer)
    answer.destroy
    redirect_to question_path(answer.question), notice: "Selected answer successfully deleted."
  end


end
