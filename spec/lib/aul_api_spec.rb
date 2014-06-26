require 'aul_api'
require 'yaml'

# Gitignored. Use your own vehicles and Carfax credentials for testing!
fixtures = YAML::load_file(File.join(__dir__, 'fixtures.yml'))
credentials = YAML::load_file(File.join(__dir__, 'credentials.yml'))

user_name = credentials["user_name"]
password = credentials["password"]
dealer_id = credentials["dealer_id"]

#  CLASS AND PUBLIC METHOD TESTS
######################################

AutoUplink.set_credentials(dealer_id, user_name, password)

puts AutoUplink.retrieve_vehicle_comments('37437175')


#  PRIVATE METHOD TESTS
######################################

# describe AutoUplink do

# 	it "is a subclass of Mechanize" do
# 		expect(AutoUplink.new).to be_a(Mechanize)
# 	end

# 	it "can log into AUL given working credentials" do
# 		#login with correct credentials should bring you to main menu
# 		aul_scraper = AutoUplink.send(:new)
# 		aul_scraper.login
# 		expect(aul_scraper.on_main_menu?).to be true
# 	end

# end

# describe '#produce_id_matrix' do

# 	it "outputs an array of hashes containing stock_number and aul_id" do
# 		aul_scraper = AutoUplink.new
# 		aul_scraper.login
# 		id_matrix = aul_scraper.produce_id_matrix
# 		expect(id_matrix[1][:stock_number]).to be_a(String)
# 		expect(id_matrix[1][:aul_id]).to be_a(String)
# 		expect(id_matrix[1][:stock_number].length).to be > 0
# 		expect(id_matrix[1][:aul_id].length).to be > 0
# 	end

# end
