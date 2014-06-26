require 'mechanize'
require 'logger'
require 'sanitize'

class AutoUplink < Mechanize

	@@login_url = "http://services.autouplinktech.com/login.cfm"
	@@logout_url = "http://services.autouplinktech.com/logout.cfm"
	@@main_menu_url = "http://services.autouplinktech.com/admin/mainoptions.cfm"
	@@comments_generator_url = "http://services.autouplinktech.com/admin/iim/navigation/home.cfm?CommentsGenerator=yes"

	# Create a Mechanize agent
	def initialize
		super
		@user_agent_alias = 'Mac Safari'
		@follow_meta_refresh = true
		@redirect_ok = true
	end

	# Outputs an array of 
	def produce_id_matrix
		self.get(@@comments_generator_url)
		self.page.frame_with(:name => 'bottom').click
		vehicle_row = self.page.search("tr")
		id_matrix = []

		vehicle_row.each do |n|
			id_matrix.push(id_hash_from_row(n))
		end

		id_matrix
	end

	def id_hash_from_row (vehicle_row)
		vehicle_entries = vehicle_row.search("td")
		{:feed_id => Sanitize.clean(vehicle_entries[0].to_s).strip, :stock_number => Sanitize.clean(vehicle_entries[1].to_s).strip}
	end

	def on_main_menu?
		self.page.search('meta').to_s.include?("http://services.autouplinktech.com/admin/mainoptions.cfm")
	end

	# Login to Auto Uplink
	def login (user, password)
		begin
		    self.get(@@login_url)
		    form = self.page.forms.first
		    form.uid = user
		    form.pid = password
		    self.submit(form)
		rescue StandardError => e
	    	logger = Logger.new(STDERR)
	    	logger.error("Could not log into AutoUplink: #{e.message}")
	    	return false
	    end

	end




end