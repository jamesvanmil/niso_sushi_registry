#! /usr/bin/ruby

table = File.open("SUSHI Content Provider Information - Sheet1.tsv", "r").read.split("\n")

##grab the header
header = table[0].split("\t")

##delete the header and the first element, which is blank
table.slice!(0,2)

@entry_list = Array.new
@organization_list = Hash.new

table.each do |line|
	'parse the table and sort through lines'
	fields = line.split("\t")
	header_index = 0
	entry_content = Hash.new
	fields.each do |field|
		entry_content[header[header_index]] = field
		header_index += 1
	end
	@entry_list << entry_content
end

@entry_list.each do |entry|
	'populate the hash of entries by organization name, storing them as arrays'
	unless @organization_list.has_key?("Organization Name") 
		@organization_list[entry["Organization Name"]] = Array.new
		@organization_list[entry["Organization Name"]] << entry
	else
		@organization_list[entry["Organization Name"]] << entry
	end
end

@organization_names = @organization_list.keys.sort


@html = String.new

##add the script
script = File.open("script.js", "r").read
@html << script

@code = 0
@code_array = ["a", "b"]
@organization_names.each do |name|
	'generate html for the site'

	##Label for organization
	@html << "<h2>#{name}</h2>"

	code_array_index = 0
	##create the appropriate number of buttons
	@organization_list[name].each do |entry|
		@html << "<input type=\"button\" onClick=\"toggle('#{@code.to_s + "-" + @code_array[code_array_index]}')\" value=\"#{entry['COUNTER_SUSHI Version']}\">"
		code_array_index += 1
	end

	code_array_index = 0
	##create the tables for each entry
	@organization_list[name].each do |entry|
		@html << "<div id=\"#{@code.to_s + "-" + @code_array[code_array_index]}\" style=\"display:none\"><table><col width=\"30%\"><tbody>"
		
		##fields to display
		field_list = [	  "COUNTER_SUSHI Version",
											"Content host/platform",
											"SUSHI contact name",
											"SUSHI contact phone",
											"Instructions for registering/using SUSHI clients with your server",
											"URL to SUSHI server",
											"Describe your Requestor ID",
											"Describe your Customer ID",
											"Describe any security mechanism",
											"Supported reports",
											"Other Notes",
											"Timestamp"	]

		##labels for each field
		display_list = {	"COUNTER_SUSHI Version" => "COUNTER_SUSHI Version",
											"Content host/platform" => "Platform",
											"SUSHI contact name" => "Contact Name",
											"SUSHI contact phone" => "Contact Phone",
											"Instructions for registering/using SUSHI clients with your server" => "Instructions",
											"URL to SUSHI server" => "Server URL",
											"Describe your Requestor ID" => "About Requestor ID",
											"Describe your Customer ID" => "About Customer ID",
											"Describe any security mechanism" => "About Security",
											"Supported reports" => "Reports Supported",
											"Other Notes" => "Other Notes",
											"Timestamp" => "Submitted"	}
		field_list.each do |key|
			@html << "<tr><td>#{display_list[key]}<br></td><td>#{entry[key]}<br></td></tr>" unless entry[key] == ""
		end
		@html << @entry_end = "</tbody></table></div>"
		code_array_index += 1
	end
	@code += 1
end

File.open("output.html", 'w') { |file| file.write(@html) }
