# the convention in Rails is to use pluralize model name if the controller
# is related to that model. For instance, if the model name is Question
# the controller name should be QuestionsController
# you can generate such controller by running:
# bin/rails g controller questions
class QuestionsController < ApplicationController

before_action(:find_question, {only: [:show, :edit, :update, :destroy]})
before_action :authorize, only: [:edit, :update, :destroy]

  def new
    authenticate_user
    # To see the question in view (empty) form page, we ahve to define @q in views as well:
    @q = Question.new
  end

  def create
    # params[:question]
    # Question.create({title: params[:question][:title], body: params[:question][:body]})
    question_params
    # question_params = params.require(:question).permit([:title, :body])
    # Question.create(question_params)
    # render text: "Inside Questions Create: #{params[question]}"
    @q = Question.new(question_params)
    @q.user = current_user
      if @q.save
        # render text: "Saved correctly!"
        redirect_to(question_path(id: @q.id))
      else
        # render text: "Didn't save correctly! #{q.errors.full_messages.join(", ")}"
        render :new, notice: "A new question is created and added to the database."
      end
    end

    def show
      # @q = Question.find(params[:id])
      # render text: params
      @answer = Answer.new
    end

    def edit
      # @q = Question.find(params[:id])
      # if current_user != @q.user
      #   redirect_to root_path, alert: "Access denied."
      # end
      redirect_to root_path, alert: "Access denied." unless can? :edit, @q
    end

    def update
      # @q = Question.find params[:id]
      question_params
      # question_params = params.require(:question).permit([:title, :body])
      if @q.update(question_params)
        redirect_to question_path(@q), notice: "Question is successfully updated."
      else
        render :edit
      end
    end

    def index
      @questions = Question.all
    end

    def destroy
      # @q = Question.find params[:id]
      @q.destroy
      flash[:notice] = "Question is successfully deleted."
      redirect_to questions_path
    end


private

    def find_question
      @q = Question.find params[:id]
    end

    def question_params
      question_params = params.require(:question).permit([:title, :body])
    end

    def authorize
      redirect_to root_path, alert: "Access denied." unless can? :manage, @q
    end

end
