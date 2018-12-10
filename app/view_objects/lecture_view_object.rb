class LectureViewObject
  def initialize(lecture)
    @lecture = lecture
  end

  def lecture?
    !@lecture.nil?
  end

  def timeframe
    @lecture.dtstart.strftime('%d-%m-%Y %H:%M-') + @lecture.dtend.strftime('%H:%M')
  end

  def lecturer
    @lecture.user.name
  end

  def subject
    @lecture.subject
  end
end
