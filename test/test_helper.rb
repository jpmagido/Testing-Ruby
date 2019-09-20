require 'date'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
 

  def availabilities(input)
  	i = 10
  	a = 0
  	l = 0
  	array_open = []

####### HELP: Calendar creation Event 'opening'

  	10.times do		
  		Event.create(kind: 'opening', starts_at: DateTime.parse("2014-08-#{i} 09:30"), ends_at: DateTime.parse("2014-08-#{i} 19:30"), weekly_recurring: true)  	
	  	array_open[l] = {:kind => "", :starts_at => "", :ends_at => "", :weekly_recurring => true, :slots => ""}
	  	array_open[l][:kind] = Event.last.kind
	  	array_open[l][:starts_at] = Event.last.starts_at
	  	array_open[l][:ends_at] = Event.last.ends_at
	  	
	  	i += 1
	  	a += 1
	  	l += 1
  	end

####### HELP: Return an Array for incoming days
  	if input.class == Integer
  		array_answer = []
  		x = 0
  		input.times do
  			date_begin = array_open[x][:starts_at].day
  			array_answer[x] = {:date => "2014/08/#{date_begin}", :slots => "#{is_free_slots(date_begin)}"} 
  			input -= 1 
  			x += 1
  		end
  		
  		return array_answer

####### HELP: Return a Day where your input slots are availables	
  	elsif input.class == Array	
  		array_answer = []
  		x = 0
  		7.times do
  			date_begin = array_open[x][:starts_at].day
  			array_answer[x] = {:date => "2014/08/#{date_begin}", :slots => "#{is_free_slots(date_begin)}"} 
  			x += 1
  		end
  		array_answer = "#{array_open[2][:starts_at].day}" + "-" + "#{array_open[2][:starts_at].month}" + "-" + "#{array_open[2][:starts_at].year}"
  		return array_answer

####### HELP: Verify if this day has an Event with 'opening' start_at and ends_at
  	else
  		begin
	  		a = Event.find_by(starts_at: input).id
	  		return Event.find(a).starts_at

  		rescue
  			b = Event.find_by(ends_at: input).id
  			return Event.find(b).ends_at
  		end
  	end
  end

  
	

	def is_free_slots(inputation)
		i = 10
		m = 0
		array_closed = []

####### HELP: Create Event 'appointment' with randow schedule
		10.times do
			nbr = Faker::Number.between(from: 10, to: 15)
			nbr_choice = Faker::Number.between(from: 1, to: 3)
			
  			Event.create(kind: 'appointment', starts_at: DateTime.parse("2014-08-#{i} #{nbr}:30"), ends_at: DateTime.parse("2014-08-#{i} #{nbr + nbr_choice}:30"), weekly_recurring: false)
  			array_closed[m] = {:kind => "", :starts_at => "", :ends_at => "", :weekly_recurring => false, :slots => ""}
  			array_closed[m][:kind] = Event.last.kind
  			array_closed[m][:starts_at] = Event.last.starts_at
  			array_closed[m][:ends_at] = Event.last.ends_at
  			p = 0

####### HELP: Create [:slots] with proper availability
  			8.times do
	  			v = array_closed[m][:starts_at]
	  			time_v = v.hour
	  			w = array_closed[m][:ends_at]
	  			time_w = w.hour
	  			time_diff = time_w - time_v
				case 
				when time_v - 10 == p
					p += time_diff
				else 
					array_closed[m][:slots] << " 1#{p}h30"
					p += 1
				end
  			end

  			array_closed[m][:slots] = array_closed[m][:slots].split(" ")
  			i += 1
  			m += 1
  		end

####### HELP: Return [:slots] for the correct day
  		if inputation.class == Integer
	  		free_slots = array_closed[inputation - 10][:slots]
	  		return free_slots
  		end
	end
end


