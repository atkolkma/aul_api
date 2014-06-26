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
		#login with correct credentials should bring you to main menu
		aul_scraper = AutoUplink.new
		aul_scraper.login(user_name, password)
		expect(aul_scraper.on_main_menu?).to be true

		#login with bogus credentials should not work
		aul_scraper = AutoUplink.new
		aul_scraper.login("bad_username", "useless_password")
		expect(aul_scraper.on_main_menu?).to be false
	end

end

describe '#produce_id_matrix' do

	it "outputs an array of hashes containing stock_number and aul_id" do
		aul_scraper = AutoUplink.new
		aul_scraper.login(user_name, password)
		id_matrix = aul_scraper.produce_id_matrix
		expect(id_matrix).to be_a(Array)
		expect(id_matrix[0]).to be_a(Hash)
		expect(id_matrix[0]["stock_number"]).to be_a(String)
		expect(id_matrix[0]["aul_id"]).to be_a(String)
		expect(id_matrix[0]["stock_number"].length).to be > 0
		expect(id_matrix[0]["aul_id"].length).to be > 0
	end

end
