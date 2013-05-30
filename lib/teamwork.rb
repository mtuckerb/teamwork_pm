require 'csv'
require 'json'
require 'open-uri'
require 'rest_client'

class TeamWork
	
	def initialize(params = {})
		
	    params.each do |k,v|
	      instance_variable_set("@#{k}",v)
	      # create accessors
	      eigenclass = class<<self; self; end
	      eigenclass.class_eval do
	        attr_accessor k
	      end
	    end
	    @base_url = BASE_URL
 	end

	def parse_time()
		#  Not used(0) Group Name, (1) Group Cost, (2) Tax 1, (3) Tax 2, (4) Group Cost w/ Tax, (5) Group Time,
		# (6) Cost ,(7) Tax 1, (8) Tax 2, (9) Cost w/ Tax, (10) Quantity, (11) Time, (12) Start Date, (13) End Date
		# (14) Description, (15) Note
		
		time_array = []
		CSV.foreach(file) do |row|
			# skip the headers and any empty rows
			next if row.empty? || row[6] == "Cost"|| row[11] == nil
			
			#parse the time into hours and minutes
			hours,minutes = row[11].split(":")
			if row[8].to_i == "$0.00"
				billthis = "no"
			else
				billthis = "yes"
			end
			puts row[8]
			month,day,year = row[12].split("/")
			time = {}
			time = {
				hours: hours.to_s, 
				minutes: minutes.to_s, 
				isbillable: billthis, 
				time: "00:00", 
				date: "20#{year}#{month}#{day}",
				description: row[14], 
				"person-id" => person_id
			} 
			
			time_array.push({"time-entry" => time})

		end
		return time_array
	end


	def post_times(times)
		url = "#{@base_url}projects/#{project_id}/time_entries.json"
		
		times.each do |time|
			jdata = JSON.generate(time)
			RestClient.post(url, jdata,{:content_type => :json})
			#puts JSON.parse(jdata)
		end
	end

	def list_people
		if defined? company_id.exist?
			url = "#{@base_url}companies/#{company_id}/people.json"
		else
			url = "#{@base_url}projects/#{project_id}/people.json"
		end
		response = RestClient.get(url)
		jdata = JSON.parse(response)
		results = []
		jdata["people"].each do |user|
			results.push({:name => user["user-name"], :id => user["id"]} )
		end
		return results
	end

	def list_projects
		url = "#{@base_url}projects.json"
		response = RestClient.get(url)
		jdata = JSON.parse(response)
		results = []
		jdata["projects"].each do |project|
			results.push({:company => project["company"]["name"], :name => project["name"], :id => project["id"] })
		end
		return results
	end

end