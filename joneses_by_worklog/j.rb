require "digest/md5"
require "savon"

user_name = "your_name"
password_md5 =  Digest::MD5.hexdigest("your_password")
bugs_txt_file = "bugs.txt"

old_bugs = []

File.open(bugs_txt_file, "a+") do |f| 
	f.each_line {|l| old_bugs << l.strip}
end

old_bugs_string = old_bugs.join("','") if old_bugs.any?

query = "fixed_in_release_name = '_KeepingUpJoneses'
	AND bugs.bug_number NOT IN ('#{old_bugs_string}')
	AND bugs.status='Pending Review' 
	AND NOT bugs.work_log LIKE '%when this bug is verified%'"
	
client = Savon.client(wsdl: "https://sugarinternal.sugarondemand.com/service/v4/soap.php?wsdl",
	logger: Logger.new("log.txt"),
	log_level: :debug,
	pretty_print_xml: true)

response = client.call(:login) do
	message "user_auth" => {"user_name" => user_name, "password" => password_md5}
end

session_id = response.body[:login_response][:return][:id]

response = client.call(:get_entry_list) do
	message(
		"session" => session_id,
		"module_name" => "Bugs",
		"query" => query #,
		#~ "order_by" => "",
		#~ "offset" => "0",
		#~ "select_fields" => ["bug_number"],
		#~ "link_name_to_fields_array" => [],
		#~ "max_results" => "1234",
		#~ "deleted" => "0",
		#~ "favorites" => false
	)
end

bugs = response.xpath("//name[text()='bug_number']/following-sibling::value").collect {|e| e.text}
File.open(bugs_txt_file, 'a') {|f| f.puts bugs}
