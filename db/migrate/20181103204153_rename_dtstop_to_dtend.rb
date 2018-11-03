class RenameDtstopToDtend < ActiveRecord::Migration[5.2]
  def change
    rename_column :lectures, :dtstop, :dtend
  end
end
