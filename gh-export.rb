require 'github_api'
require 'prawn'
require_relative 'getMondaySince'
require_relative 'budgetConf'

# Edit these accordingly
# TODO factor out into a separate config file
ghUser = ENV['user_name_pass']		# 'username:password'
orgUser = ENV['org_user']			# 'oreganizationName'
repoOne = ENV['repo_one']			# 'repoName'
repoTwo = ENV['repo_two']			# 'repoName'
issueState = ENV['issue_state']		# 'closed'
mondaySince = getMondaySin			# getMondaySince returns the Monday of the week in YYYY-MM-DDTHH:MM:SSZ
i = 0								# issue count

# Setup GitHub Session
# TODO change to auth token
github = Github.new basic_auth: ghUser

# Setup PDF
pdf = Prawn::Document.new
pdf.font_families.update(
	"Roboto" => {
		:normal => "Roboto-Regular.ttf",
		:bold => "Roboto-Bold.ttf"
	}
)
pdf.font "Roboto"

# GET issues from repoOne and print
# Finished Create titles
# Finished adjust fonts and styling
t = Time.parse(getMonday.to_s)
pdf.text t.strftime("%B %e - ") + Time.now.strftime("%B %e, %Y"), :size => 20
pdf.float do
	pdf.move_down 30
	github.issues.list user: orgUser,
		repo: repoOne,
		since: mondaySince,
		state: issueState do |issue|
			# Issue number and title
			pdf.text "#" + issue.number.to_s + " " + issue.title, :size => 12, :style => :bold

			# Issue description
			# TODO handle html
			pdf.text issue.body, :size => 10
			pdf.pad_bottom(20) {}
			i =  i + 1 #increment issue count
	end
end
pdf.text i.to_s + " closed issues"
i = 0

# GET issues from repoTwo
# TODO remove this and loop it
puts "\nCarepointeVendorIOS\n~~~~~~~~~~~~~~"
github.issues.list user: orgUser, repo: repoOne, since: mondaySince, state: issueState do |issue|
puts "\n#" + issue.number.to_s + " " + issue.title + "\n" + issue.body + "\n\n======"
end

# render PDF
# TODO programmatically create relevant file name ie. "Carepointe_Report_5-1_5-5.pdf"
fileStr =  Time.now.strftime("Carepointe-Report--%m-%d-%Y.pdf")
puts fileStr
pdf.render_file "assignment.pdf"