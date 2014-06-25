require 'aul_api'
require 'yaml'

# Gitignored. Use your own vehicles and Carfax credentials for testing!
fixtures = YAML::load_file(File.join(__dir__, 'fixtures.yml'))
credentials = YAML::load_file(File.join(__dir__, 'credentials.yml'))

user_name = credentials["user_name"]
password = credentials["password"]

describe AutoUplink do

	it "is a subclass of Mechanize" do
		expect(AutoUplink.new).to be_a(Mechanize)
	end

	it "can log into AUL given working credentials" do
		expect(AutoUplink.new.login(user_name, password).uri.to_s).to eq("http://services.autouplinktech.com/admin/mainoptions.cfm")
		expect(AutoUplink.new.login("bad_username", "useless_password").uri.to_s).to eq("http://services.autouplinktech.com/login.cfm")
	end

	it "can locate a vehicle, once logged in" do
		AutoUplink.new.login(user_name, password)
		# expect(aul_scraper.find_vehicle(vehicle)).to_not raise_error
	end


end