# CarePointe Report Generator
A Ruby script to automatically generate a report on the GitHub/Waffle issues that were closed within the week.

## Requirements
1. Basic command line knowledge
2. Login credentials for the MogulVegas GitHub
2. Mac, Linux, or Windows with Unix shell
3. Ruby environment - [Download here](https://rvm.io/)
4. Bundler for Ruby - [Instructions here](http://bundler.io/)
## Setting Up
1. run `git clone https://github.com/MogulVegas/github-issues-export.git`
2. run `bundle`
3. copy and rename [budgetConf.rb.sample](https://github.com/MogulVegas/github-issues-export/blob/master/budgetConf.rb.sample) as budgeConf.rb and replace `'username:password'` with  login credentials that have access to the MogulVegas GitHub
## Use
From the main directory, run `ruby gh-export.rb`. This generates a PDF in the same directory that includes the titles and description of all of the issues that were closed since the Monday of the week to the current day. This pulls issues from both the webapp and vendorIOSapp repositories. The PDF is titled "Carepointe-Report--05-10-2017.pdf" (with corresponding date).