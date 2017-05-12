# returns true of file was edited within the last 3 seconds
def recEdit(file)
	t1 = File.ctime(file)
	t2 = Time.now - 3
	return t1 > t2
end
