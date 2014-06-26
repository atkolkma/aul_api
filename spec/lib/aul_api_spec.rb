require 'aul_api'
require 'yaml'

# Gitignored. Use your own vehicles and Carfax credentials for testing!
fixtures = YAML::load_file(File.join(__dir__, 'fixtures.yml'))
credentials = YAML::load_file(File.join(__dir__, 'credentials.yml'))

login = credentials["login"]
password = credentials["password"]
dealer_id = credentials["dealer_id"]

AutoUplink.set_credentials({dealer_id: dealer_id, login: login, password: password})

describe AutoUplink do

  #  CLASS TESTS
  ######################################

  it "is a subclass of Mechanize" do
    expect(AutoUplink.new).to be_a(Mechanize)
  end

  it "can log into AUL given working credentials" do
    #login with correct credentials should bring you to main menu
    aul_scraper = AutoUplink.send(:new)
    aul_scraper.login
    expect(aul_scraper.on_main_menu?).to be true
  end

  
  #  CLASS METHOD TESTS
  ######################################

  describe '.id_matrix' do
    it "outputs an array of hashes with stock numbers and AutoUplink ids" do
		  test_matrix = AutoUplink.id_matrix
		  expect(test_matrix[1][:stock_number]).to be_a(String)
		  expect(test_matrix[1][:aul_id]).to be_a(String)
		  expect(test_matrix[1][:stock_number].length).to be > 0
		  expect(test_matrix[1][:aul_id].length).to be > 0
    end
  end

	describe '.retrieve_vehicle_comments' do
    it "outputs a String if the method arguments match an correct AutoUplink id" do
      expect(AutoUplink.retrieve_vehicle_comments(fixtures["vehicle1"]["aul_id"])).to be_a(String)
    end
	end
	
  # Destructive. But should revert DB back to original state
  describe '.update_vehicle_comments' do
    it "updates a vehicle's comments in the AutoUplink databse" do
      original_comment = AutoUplink.retrieve_vehicle_comments(fixtures["vehicle1"]["aul_id"])
      new_comment = original_comment + '.'
      AutoUplink.update_vehicle_comments(fixtures["vehicle1"]["aul_id"], new_comment)
      expect(AutoUplink.retrieve_vehicle_comments(fixtures["vehicle1"]["aul_id"])).to eq(new_comment)

      # To fix the comment in the database
      AutoUplink.update_vehicle_comments(fixtures["vehicle1"]["aul_id"], original_comment)
    end
  end


  #  INSTANCE METHOD TESTS
  ####################################

  describe '#produce_id_matrix' do

    it "outputs an array of hashes containing stock_number and aul_id" do
      aul_scraper = AutoUplink.new
      aul_scraper.login
      id_matrix = aul_scraper.produce_id_matrix
      expect(id_matrix[1][:stock_number]).to be_a(String)
      expect(id_matrix[1][:aul_id]).to be_a(String)
      expect(id_matrix[1][:stock_number].length).to be > 0
      expect(id_matrix[1][:aul_id].length).to be > 0
    end

  end

end


