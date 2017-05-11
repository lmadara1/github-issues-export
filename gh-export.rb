require 'github_api'
require 'prawn'
require_relative 'getMondaySince'
require_relative 'budgetConf'

# Edit these variables from the budgetConf.rb file
$ghUser = ENV['user_name_pass']
$orgUser = ENV['org_user']
repoOne = ENV['repo_one']
repoTwo = ENV['repo_two']
$issueState = ENV['issue_state']

$mondaySince = getMondaySin			# getMondaySince returns the Monday of the week in YYYY-MM-DDTHH:MM:SSZ

# Setup GitHub Session
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

def pdfExport(repo)
	i = 0
	# Create PDF Header
	t = Time.parse(getMonday.to_s)
	$pdf.text "CarePointe Report", :size => 38
	$pdf.text  t.strftime("%B %e - ") + Time.now.strftime("%B %e, %Y"), :size => 20
	$pdf.move_down 20

	# Create PDF body
	$pdf.float do
		$pdf.move_down 38
		$github.issues.list user: $orgUser,
			repo: repo,
			since: $mondaySince,
			state: $issueState do |issue|
				# Issue number and title
				$pdf.text "#" + issue.number.to_s + " " + issue.title, :size => 12, :style => :bold

				# Issue description
				issueBod = issue.body.gsub(/<p>/,"\n")
				$pdf.text issueBod.gsub(/[<]+(?<=<)[^>]+(?=>)+[>]/,''), :size => 10
				$pdf.pad_bottom(20) {}
				i =  i + 1 # increment issue count
		end
		$pdf.start_new_page
	end
	# Export number of issues closed
	$pdf.text i.to_s + " closed issues in " + repo, :size => 20
	$pdf.stroke_horizontal_rule
end

pdfExport(repoOne)
# $pdf.start_new_page
pdfExport(repoTwo)

# render PDF
fileStr =  Time.now.strftime("Carepointe-Report--%m-%d-%Y.pdf")
$pdf.render_file fileStr