class LectureDecorator < SimpleDelegator
  def timeframe
    dtstart.strftime('%d-%m-%Y %H:%M-') + dtend.strftime('%H:%M')
  end

  def lecturer
    user.name
  end
end
