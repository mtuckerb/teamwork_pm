#!/usr/bin/ruby
require './lib/teamwork'
require 'trollop'

opts = Trollop::options do
	opt :file, "input file", :type => :string
	opt :project, "project id. Use --list-project for complete list", :type => :string
	opt :person, "person_id. Use --list-person for complete list", :type => :string
	opt :company_id, "company_id", :type => :string
	opt :api_key, "Your API key", :type => :string
	opt :post_times
	opt :list_people
	opt :list_projects
end

Trollop::die :api_key, "--api_key is a required argument" unless opts[:api_key]

# Set this to your organization 
BASE_URL = "https://#{opts[:api_key]}@<your subdomain>.teamworkpm.net/"

unless opts[:list_people] || opts[:list_projects]
	Trollop::die :file, "must specify a file with --file <filename>" unless  opts[:file] 
	Trollop::die :person, "must specify a person-id with --person" unless opts[:person]
	Trollop::die :project, "must specify a project id with --project" unless opts[:project]
end

unless opts[:list_projects] || opts[:company_id]
	Trollop::die :project, "must specify a project id with --project or company id with --company" unless opts[:project]

end

teamwork = TeamWork.new(
	:api_key => opts[:api_key],
	:project_id => opts[:project],
	:person_id => opts[:person],
	:file => opts[:file],
	:company_id => opts[:company]
	)

teamwork.post_times(teamwork.parse_time) if opts[:post_times]
puts teamwork.list_people() if opts[:list_people]
puts teamwork.list_projects() if opts[:list_projects]



