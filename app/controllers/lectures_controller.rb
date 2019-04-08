class LecturesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_lecture, except: :index

  # +GET /lectures+
  #
  # Returns all the lectures for the current user
  def index
    @lectures = current_user.lectures
  end

  # +GET /lectures/:id+
  #
  # Returns info about a lecture with specific id
  def show
  end

  # +GET /lectures/:id/edit+
  #
  # Returns edit form for a lecture with specific id
  def edit
  end

  # +PUT /lectures/:id+
  #
  # Updates info for a lecture with specific id
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
    @lecture = LectureDecorator.new(Lecture.find(params[:id]))
    render(status: :forbidden) unless @lecture.user == current_user
  end
end
