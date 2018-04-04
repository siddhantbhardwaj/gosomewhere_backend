class AddDefaultValueToAttendees < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :attendees, :integer, default: 0
    
    Event.where(attendees: nil).each do |event|
      event.update_attributes({attendees: 0})
    end
  end
end
