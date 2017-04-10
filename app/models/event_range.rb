class EventRange
  def self.add_events(params)
    event_group = SecureRandom.hex[0,10].upcase
    event_time  = Time.parse(params[:date].split(' ')[1])
    date_start  = Date.parse(params[:date])
    date_end    = Date.parse(params[:date_end])
    if date_start == date_end
      dates = [date_start]
    elsif params[:repeats] == 'daily'
      dates = (date_start..date_end)
    elsif params[:repeats] == 'monthly'
      dates = get_dates((date_start..date_end), :mday)
    elsif params[:repeats] == 'yearly'
      dates = get_dates((date_start..date_end), :yday)
    else # weekly and fortnightly
      day_of_week = date_start.wday
      # for weekly we use every wday that is same as start_date
      dates = (date_start..date_end).select { |d| day_of_week == d.wday }
      # for fortnightly we need to filter out every second wday that is same as start_date
      dates = dates.select.with_index { |_,i| i % 2 == 1 } if params[:repeats] == 'fortnightly'
    end
    events = []
    dates.each do |date|
      dtime = date.to_datetime + event_time.seconds_since_midnight.seconds
      events << Event.add_invite({date: dtime,
                        place: params[:place],
                        user_id: params[:user_id],
                        event_group: event_group,
                        max_places: params[:max_places].to_i
      })
    end
    events.compact # remove nil objects
  end

  private

  def self.get_dates(date_range, day_to_use)
    filter_day = date_start.send(:day_to_use)
    date_range.select { |d| filter_day == d.send(:day_to_use) }
  end
end
