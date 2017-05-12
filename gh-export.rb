require 'github_api'
require 'prawn'
require_relative 'getMondaySince'
require_relative 'budgetConf'
require_relative 'recentEdit'

# Edit these variables from the budgetConf.rb file
$ghUser = ENV['user_name_pass']
$orgUser = ENV['org_user']
repoOne = ENV['repo_one']
repoTwo = ENV['repo_two']
$issueState = ENV['issue_state']

$mondaySince = getMondaySin			# getMondaySince returns the Monday of the week in YYYY-MM-DDTHH:MM:SSZ

# Setup GitHub Session
puts "beep boop: setting up GitHub API session"
$github = Github.new basic_auth: $ghUser

# Setup PDF
$pdf = Prawn::Document.new
$pdf.font_families.update(
	"Roboto" => {
		:normal => "Roboto-Regular.ttf",
		:bold => "Roboto-Bold.ttf"
	}
)
$pdf.font "Roboto"

# Create PDF Header
puts "beep boop: creating PDF"
$pdf.text "CarePointe Report", :size => 38
$pdf.text  getMonday.strftime("%B %e - ") + Time.now.strftime("%B %e, %Y"), :size => 20
$pdf.move_down 20

# Export function
# TODO move this function to different file
def pdfExport(repo)
	# Retrieve list of closed issues from API
	# TODO error handling
	ghList = $github.issues.list user: $orgUser,
		repo: repo,
		since: $mondaySince,
		state: $issueState
	
	# Print header with number of issues closed
	$pdf.text ghList.length.to_s + " closed issues in " + repo, :size => 20
	$pdf.stroke_horizontal_rule
	$pdf.move_down 20

	# Print list
	ghList.each do |issue|
		# Issue number and title
		$pdf.text "#" + issue.number.to_s + " " + issue.title.to_s, :size => 12, :style => :bold

		# Issue description
		issueBod = issue.body.to_s.gsub(/<p>/,"\n")
		$pdf.text issueBod.gsub(/[<]+(?<=<)[^>]+(?=>)+[>]/,''), :size => 10
		$pdf.pad_bottom(20) {}
	end
end

# Call export function for both repos
pdfExport(repoOne)
$pdf.start_new_page
pdfExport(repoTwo)

# Render PDF
puts "beep boop: exporting PDF"
fileStr =  Time.now.strftime("Carepointe-Report--%m-%d-%Y.pdf")
# Finished add error catching
begin
	$pdf.render_file fileStr
rescue Exception => e
	case e
	when Errno::EACCES
		puts "BEEP BEEP BEEP! A PDF with the same name is open in another application. Please close and try again"
	else
		puts "BEEP BEEP BEEP! I don't even know..." + e.to_s
	end
end


# Checking to see if file render was success
# Finished recent Edit check
if recEdit(fileStr)
	puts "beep boop: " + fileStr + " was generated!"
else
	puts "BEEP BEEP BEEP! err... something didn't go right"
end