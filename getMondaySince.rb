require 'date'

#TODO use only Time functions and remove date require
def getMonday
	d = Date.parse(Time.now.to_s)
 	while d.monday? == false do
 		d = d.prev_day
 	end
 return d
end

def getMondaySin
	d = getMonday.to_s + "T00:00:00Z"
	return d
end