require 'mechanize'
require 'logger'

class AutoUplink < Mechanize

	@@login_url = "http://services.autouplinktech.com/login.cfm"
	@@logout_url = "http://services.autouplinktech.com/logout.cfm"
	@@main_menu_url = "http://services.autouplinktech.com/admin/mainoptions.cfm"

	# Create a Mechanize agent
	def initialize
		super
		@user_agent_alias = 'Mac Safari'
		@follow_meta_refresh = true
		@redirect_ok = true
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
	    end
	end

	

end