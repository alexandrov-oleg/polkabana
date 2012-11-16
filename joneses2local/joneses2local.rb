require "rubygems"
require "savon"
require "digest/md5"
require "yaml"

class SugarSOAP
	def initialize wsdl_url, log_file
		Savon.configure do |config|
			config.logger = Logger.new log_file
			config.pretty_print_xml = true
		end
		
		@client = Savon::Client.new do |wsdl, http|
			http.auth.ssl.verify_mode = :none
			wsdl.document = wsdl_url
		end
	end
	
	def login user_name, password_md5
		response = @client.request :login do
			soap.body = {
				"user_auth" => {"user_name" => user_name, "password" => password_md5}
			}
		end
		
		@session_id = response.body.to_hash[:login_response][:return][:id]
	end
	
	def get_bugs query, offset
		session = @session_id # @session_id is not visible inside block
		response = @client.request :get_entry_list do
			soap.body = {
				"session" => session,
				"module_name" => "Bugs",
				"query" => query,
				"order_by" => "",
				"offset" => offset
			}
		end
	end
	
	def get_all_jon_bugs_as_hashes
		# returns array of hashes like 
		# {:item=>[{:name=>"assigned_user_name", :value=>"Developer", :"@xsi:type"=>"tns:name_value"}, {:name=>"modified_by_name", :value=>"jmertic", :"@xsi:type"=>"tns:name_value"}, {:name=>"created_by_name", :value=>"bug_portal", :"@xsi:type"=>"tns:name_value"}, {:name=>"id", :value=>"5c2c033f-68f4-fa4e-547e-5095855f5c08", :"@xsi:type"=>"tns:name_value"}, {:name=>"name", :value=>"Add the capability to retrieve the participant status in iCal", :"@xsi:type"=>"tns:name_value"}, {:name=>"date_entered", :value=>"2012-11-03 20:59:19", :"@xsi:type"=>"tns:name_value"}, {:name=>"date_modified", :value=>"2012-11-07 20:27:24", :"@xsi:type"=>"tns:name_value"}, {:name=>"modified_user_id", :value=>"bc56805c-0252-ee43-fb95-476967a4011a", :"@xsi:type"=>"tns:name_value"}, {:name=>"created_by", :value=>"c2a93408-f64a-1487-0965-4356f8b003b5", :"@xsi:type"=>"tns:name_value"}, {:name=>"description", :value=>"We have participant status in Sugar Calls & Meetings, the feature proposed is to retrieve this information in the generated iCal file as is describe in the RFC http://tools.ietf.org/html/rfc2445 in section &quot;4.2.12 Participation Status&quot;\n\nWe will provide the pull request number associated with this feature in the first comment like to this bug.", :"@xsi:type"=>"tns:name_value"}, {:name=>"deleted", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"assigned_user_id", :value=>"b483adc8-1871-40d2-3948-433595a1d528", :"@xsi:type"=>"tns:name_value"}, {:name=>"team_id", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"team_set_id", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"team_count", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"team_name", :value=>"Global", :"@xsi:type"=>"tns:name_value"}, {:name=>"bug_number", :value=>"58102", :"@xsi:type"=>"tns:name_value"}, {:name=>"type", :value=>"enhancement", :"@xsi:type"=>"tns:name_value"}, {:name=>"status", :value=>"Pending", :"@xsi:type"=>"tns:name_value"}, {:name=>"priority", :value=>"Medium", :"@xsi:type"=>"tns:name_value"}, {:name=>"resolution", :value=>"Fixed", :"@xsi:type"=>"tns:name_value"}, {:name=>"system_id", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"work_log", :value=>"&lt;b&gt;John Mertic on 11-07-2012 at 12:27pm&lt;/b&gt;\nPulled in PR", :"@xsi:type"=>"tns:name_value"}, {:name=>"found_in_release", :value=>"6edf2271-b615-0195-a5d9-5089a1604d4c", :"@xsi:type"=>"tns:name_value"}, {:name=>"release_name", :value=>"6.5.7", :"@xsi:type"=>"tns:name_value"}, {:name=>"fixed_in_release", :value=>"9385ad44-3ead-6617-b217-4d02b12a8cd3", :"@xsi:type"=>"tns:name_value"}, {:name=>"fixed_in_release_name", :value=>"_KeepingUpJoneses", :"@xsi:type"=>"tns:name_value"}, {:name=>"source", :value=>"External", :"@xsi:type"=>"tns:name_value"}, {:name=>"product_category", :value=>"Calendar", :"@xsi:type"=>"tns:name_value"}, {:name=>"portal_viewable", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"sugar_edition_c", :value=>"all", :"@xsi:type"=>"tns:name_value"}, {:name=>"third_party_integration_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"contribution_agreement_c", :value=>"CompletePartner", :"@xsi:type"=>"tns:name_value"}, {:name=>"feature_backlog_priority_num_c", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"product_c", :value=>"Sugar", :"@xsi:type"=>"tns:name_value"}, {:name=>"developer_guide_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"fromautomation_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"application_guide_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"sprint_number_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"team_assigned_c", :value=>"none", :"@xsi:type"=>"tns:name_value"}, {:name=>"translation_upd_req_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"pm_assigned_to_c", :value=>"TBD", :"@xsi:type"=>"tns:name_value"}, {:name=>"pm_status_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"story_points_c", :value=>"2", :"@xsi:type"=>"tns:name_value"}, {:name=>"sprint_group_c", :value=>"TBD", :"@xsi:type"=>"tns:name_value"}, {:name=>"internal_status_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"actual_time_spent_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"bug_id_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"code_impacts_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"code_review_complete_c", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"display_in_portal_c", :value=>"all_users", :"@xsi:type"=>"tns:name_value"}, {:name=>"due_date_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"estimated_time_spent_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"feature_backlog_group_c", :value=>"O", :"@xsi:type"=>"tns:name_value"}, {:name=>"fix_proposed_c", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"iteration_c", :value=>"I", :"@xsi:type"=>"tns:name_value"}, {:name=>"portal_name_c", :value=>"cmourizard", :"@xsi:type"=>"tns:name_value"}, {:name=>"regressed_by_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"regression_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"release_notes_c", :value=>"1", :"@xsi:type"=>"tns:name_value"}, {:name=>"requirements_status_c", :value=>"Req_Not_Needed", :"@xsi:type"=>"tns:name_value"}, {:name=>"souceforge_id", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"subcategory_c", :value=>{:"@xsi:type"=>"xsd:string"}, :"@xsi:type"=>"tns:name_value"}, {:name=>"triaged_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"ui_changes_c", :value=>"0", :"@xsi:type"=>"tns:name_value"}, {:name=>"modified_user_name", :value=>"John Mertic", :"@xsi:type"=>"tns:name_value"}], :"@xsi:type"=>"SOAP-ENC:Array", :"@soap_enc:array_type"=>"tns:name_value[66]"}
		
		bugs = []
		query = "fixed_in_release_name = '_KeepingUpJoneses' AND bugs.status='Pending'"
		offset = 0
			
		loop do
			response_h = get_bugs(query, offset).to_hash
			result_count = response_h[:get_entry_list_response][:return][:result_count]
			items = response_h[:get_entry_list_response][:return][:entry_list][:item]
			
			if items.instance_of? Hash
				bugs << items[:name_value_list]
			elsif items.instance_of? Array
				items.each {|item| bugs << item[:name_value_list]}
			end
			
			if result_count == "20"
				offset += 20
			else
				break
			end							
		end
		
		bugs
	end
	
	def post_bug b
		session = @session_id # @session_id is not visible inside block
		
		response = @client.request :set_entry do
			soap.body = {
				"session" => session,
				"module_name" => "Bugs", 
				"name_value_list" => {
					"name" => b.subj,
					"description" => b.description,
					"created_by" => b.created_by,
					"date_entered" => b.date_entered,
					"resolution" => b.resolution,
					"work_log" => b.worklog,
					"source_number_c" => b.bug_number
				}
			}
		end
	end
	

end

class SugarBug
	attr_accessor :subj, :bug_number, :created_by, :date_entered, :description, :resolution, :worklog
	
	def self.set_imported_bugs_file_name file_name
		@@imported_bugs_file_name = file_name
	end
	
	def dump_number
		File.open(@@imported_bugs_file_name, 'a') {|f| f.puts self.bug_number}
	end
	
	def new_bug?
		@@imported_bug_numbers ||= []
		
		File.open(@@imported_bugs_file_name, 'r') do |f|
			f.each_line{|l| @@imported_bug_numbers << l.strip}
		end unless @@imported_bug_numbers.any?
		
		!@@imported_bug_numbers.include? self.bug_number
	end
			
	def initialize h
		#~ {:item=>[
		#~ {:name=>"created_by_name", :value=>"augm_jack", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"id", :value=>"e5c9ff53-b40a-938a-2828-45b60f1c317c", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"name", :value=>"No warning message -\u00E2\u20AC\u0153No Optimums were saved with your InboundEmail mailbox. Please review the settings\u00E2\u20AC\u009D- is displayed on invalid inbound mailbox\u00E2\u20AC\u2122s detail view created by Campaign Email Setup wizard.", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"date_entered", :value=>"2007-01-23 13:35:03", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"date_modified", :value=>"2012-10-31 13:47:54", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"modified_user_id", :value=>"5c85f96c-2226-c8a0-9079-4e9e9acb0c8d", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"created_by", :value=>"3ecbac36-da31-be36-f10d-444460ce6668", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"description", :value=>"*** Submitted by Josephine Zhu***\nEnvironment: Stack 5: Linux FC4, Apache 2.0.55, PHP 5.1.2, Oracle 10g, IE 6.0.\nSugarCRM 4.5.1GA Enterprise (build 1184).\nInstall: Full installation.\n\nReproduce steps:\n1.\tLogin to SugarCRM as a valid admin user.\n2.\tGo to Campaigns module.\n3.\tLaunch Email Setup wizard.\n4.\tClick \u00E2\u20AC\u0153Next\u00E2\u20AC button on \u00E2\u20AC\u0153Setup Email\u00E2\u20AC page of Email Setup wizard.\n5.\tCreate an invalid mailbox, such as incorrect user name or password, and click \u00E2\u20AC\u0153Next\u00E2\u20AC button on \u00E2\u20AC\u0153New Mail Box\u00E2\u20AC page.\n6.\tClick \u00E2\u20AC\u0153Save\u00E2\u20AC button on \u00E2\u20AC\u0153Summary\u00E2\u20AC page.\n7.\tGo to Admin -&gt; Inbound Email.\n8.\tGo to the newly created mailbox&#039;s detail view.\n9.\tObserve that no warning message is displayed at the top of mail box detail view.\n\nExpected result: Warning message: \u00E2\u20AC\u0153No Optimums were saved with your InboundEmail mailbox. Please review the settings\u00E2\u20AC is displayed on the invalid inbound mailbox\u00E2\u20AC\u2122s detail view.\nActual result: No warning message: \u00E2\u20AC\u0153No Optimums were saved with your InboundEmail mailbox. Please review the settings\u00E2\u20AC is displayed on the invalid inbound mailbox\u00E2\u20AC\u02DCs detail view.\n\nMore info:\n1. Found when doing ad-hoc testing and added to test case: Cam-258.\n2. This feature does not exist in 4.5.0 version.\n", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"deleted", :value=>"0", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"assigned_user_id", :value=>"82ab35b7-655e-e3e5-1318-447dffe09d54", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"team_id", :value=>"1", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"team_set_id", :value=>"1", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"team_count", :value=>"1", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"team_name", :value=>"Global", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"bug_number", :value=>"11203", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"type", :value=>"Defect", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"status", :value=>"Pending", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"priority", :value=>"High", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"resolution", :value=>"Fixed", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"system_id", :value=>"1", :"@xsi:type"=>"tns:name_value"}, 
		#~ {:name=>"work_log", :value=>"Checked by Martin - May 22, 2009\nReproduced, and propose to fix.\n\n&lt;b&gt;Geno Patterson on 10-12-2011 at 08:24pm&lt;/b&gt;\nbehavior reproduced on Stack 65 running Ent 6.2.4 (build 6706) while running test case 1200 (http://74.85.23.198/bugzilla/tr_show_case.cgi?case_id=1200)\n- note: the message is not seen after saving from the email setup wizard in the Campaigns module, however, if you edit and resave the inbound email record via Admin &gt; Email Settings the &#039;no optimums&#039; message is then seen upon saving the record\nRe-opening Bug.\n\n&lt;b&gt;Swapna Rayirathil on 12-09-2011 at 01:15pm&lt;/b&gt;\nsame issue seen on \nStack 68:\nWindows 7 IIS-7.5 (FastCGI) 5.3.6 MSSQL-2008 (MSSQL driver 2.0.1)\nIE 8\n\nTested on IE 8 Sugar Ult version 6.3.1 build 7075\n\n&lt;b&gt;David Safar on 01-09-2012 at 03:00pm&lt;/b&gt;\nMoving to _6.4.0.patch, as there are no more 6.3 patches planned.\n\n&lt;b&gt;Eddy Ramirez on 01-31-2012 at 01:10pm&lt;/b&gt;\nError is now displayed when a save is done and no optimum settings are found.  The user is taken back to the inbound email page of the wizard.  Since the wizard was meant for &#039;set up&#039; and not editing, a link is provided to the admin page for user to review settings.\n\nBe aware that a failed optimum test can take several minutes to finish (took approx. 8 minutes during my testing on local machine).  That is not a bug, it just takes that long for the email connection to time out for each combination tried.\n\nsugarcrm/modules/Campaigns/WizardEmailSetup.html\nsugarcrm/modules/Campaigns/WizardEmailSetup.php\nsugarcrm/modules/Campaigns/WizardEmailSetupSave.php\nsugarcrm/modules/Campaigns/language/en_us.lang.php\nsugarcrm/modules/InboundEmail/Save.php\nsugarcrm/tests/modules/Campaigns/Bug11203Test.php\n\n\ngit commit -m &#039; bug 11203 - display error in campaign wizard when inbound email save with no optimums found occurs &#039; sugarcrm/modules/Campaigns/WizardEmailSetup.html  sugarcrm/modules/Campaigns/WizardEmailSetup.php  sugarcrm/modules/Campaigns/WizardEmailSetupSave.php  sugarcrm/modules/Campaigns/language/en_us.lang.php  sugarcrm/modules/InboundEmail/Save.php sugarcrm/tests/modules/Campaigns/Bug11203Test.php\nhttps://github.com/sugarcrm/Mango/pull/2053", :"@xsi:type"=>"tns:name_value"},
		#~ {:name=>"modified_user_name", :value=>"Sergey Morozov", :"@xsi:type"=>"tns:name_value"}], :"@xsi:type"=>"SOAP-ENC:Array", :"@soap_enc:array_type"=>"tns:name_value[66]"}
		
		@subj = h[:item].find{|e| e[:name] == "name"}[:value]
		@bug_number = h[:item].find{|e| e[:name] == "bug_number"}[:value]
		@created_by = h[:item].find{|e| e[:name] == "created_by"}[:value]
		@date_entered = h[:item].find{|e| e[:name] == "date_entered"}[:value]
		@description = h[:item].find{|e| e[:name] == "description"}[:value]
		@resolution = h[:item].find{|e| e[:name] == "resolution"}[:value]
		@worklog = h[:item].find{|e| e[:name] == "work_log"}[:value]		
	end
	
end

logger = Logger.new "joneses2local.log"
SugarBug.set_imported_bugs_file_name "bug_numbers.txt"

cupertino_log_file = "cupertino_joneses.log"
cupertino_wsdl_url = "https://sugarinternal.sugarondemand.com/soap.php?wsdl"
cupertino_user_name = "xxxxxxxxxxx"
cupertino_password_md5 =  Digest::MD5.hexdigest("xxxxxxxxxxx")

qa_log_file = "qa_joneses.log"
qa_wsdl_url = "http://172.30.1.144/656_ent/service/v4/soap.php?wsdl"
qa_user_name = "xxxxxxxxxxx"
qa_password_md5 =  Digest::MD5.hexdigest("xxxxxxxxxxx")

cupertino_client = SugarSOAP.new cupertino_wsdl_url, cupertino_log_file
cupertino_client.login cupertino_user_name, cupertino_password_md5
bugs_hashes = cupertino_client.get_all_jon_bugs_as_hashes

logger.info "exported #{bugs_hashes.size} from Cupertino"

qa_client = SugarSOAP.new qa_wsdl_url, qa_log_file
qa_client.login qa_user_name, qa_password_md5

bugs_hashes.each do |b_hash|
	b = SugarBug.new b_hash
	
	if b.new_bug?
		begin
		qa_client.post_bug b
		b.dump_number
		
		logger.info "imported new bug #{b.bug_number}"
		
		rescue => e
		logger.error "failed import of bug #{b.bug_number}, see qa_joneses.log"
		logger.error e
		end
	end
	
end
