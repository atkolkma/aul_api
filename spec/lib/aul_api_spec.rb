require 'aul_api'
require 'yaml'
fixtures = YAML::load_file(File.join(__dir__, 'fixtures.yml'))
credentials = YAML::load_file(File.join(__dir__, 'credentials.yml'))

describe AutoUplink do

	aul_scraper = AutoUplink.new

	it "is a subclass of Mechanize" do
		expect(aul_scraper).to be_a(Mechanize)
	end

	it "can log into AUL given working credentials" do
		expect(aul_scraper.login).not_to raise_error
	end

	it "can locate a vehicle, once logged in" do
		aul_scraper.login
		expect(aul_scraper.find_vehicle(vehicle)).to_not raise_error
	end


end