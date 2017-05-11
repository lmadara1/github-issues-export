def getMonday
	d = Time.now
 	while d.monday? == false do
 		d = d - 86400
 	end
 return d
end

def getMondaySin
	d = getMonday.strftime("%Y-%m-%dT00:00:00Z")
	return d
end