class LecturesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_lecture, except: :index

  def index
    @lectures = current_user.lectures
  end

  def show
    @lecture_view_object = LectureViewObject.new(@lecture)
  end

  def edit
  end

  def update
    if @lecture.update(lecture_params)
      flash[:notice] = 'Lecture has been sucessfully updated.'
      redirect_to @lecture
    else
      render 'edit'
    end
  end

  private
  def lecture_params
    params.require(:lecture).permit(:dtstop, :subject)
  end

  def load_lecture
    @lecture = Lecture.find(params[:id])
    render(status: :forbidden) unless @lecture.user == current_user
  end
end
