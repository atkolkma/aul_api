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
		# .uri.to_s doesn't work here. You must search meta tag to get the redirected page.
		expect(AutoUplink.new.login(user_name, password).search('meta').to_s.include?("http://services.autouplinktech.com/admin/mainoptions.cfm")).to be true
		expect(AutoUplink.new.login("bad_username", "useless_password").search('meta').to_s.include?("http://services.autouplinktech.com/admin/mainoptions.cfm")).to be false
	end

end

describe '#produce_id_matrix' do

	it "outputs an array of hashes given the right dealer credentials"

	it "returns an array of hashes containing stock_number and aul_id"

end
