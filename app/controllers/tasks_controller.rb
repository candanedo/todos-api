class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_task, only: [:show, :update]

  def index
    @tasks = current_user.tasks.filter(filtering_params)

    render json: @tasks
  end

  def uncompleted
    render json: current_user.tasks.uncompleted
  end

  def completed
    render json: current_user.tasks.completed
  end

  def show
    render json: @task
  end

  def create
    @task = current_user.tasks.new(permitted_params)

    if @task.save
      render json: @task
    else
      render json: @task.errors.full_messages
    end
  end

  def update
    if @task.update(permitted_params)
      render json: @task.reload
    else
      render json: @task.errors
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])

    if @task.destroy
      render json: { error: false, message: 'Successfully deleted task' }
    else
      render json: { error: true, message: @task.errors.full_messages }
    end
  end

  private

  def find_task
    @task = current_user.tasks.find(params[:id])
  end

  def permitted_params
    params.require(:task).
      permit(:title, :completed, notes_attributes: [:id, :content])
  end

    def filtering_params
    params.slice(
      :completed
    ).reject{|_, v| v.blank?}.permit!
  end
end
