require 'mechanize'
require 'logger'
require 'sanitize'

class AutoUplink < Mechanize

  @@login_url = "http://services.autouplinktech.com/login.cfm"
  @@logout_url = "http://services.autouplinktech.com/logout.cfm"
  @@main_menu_url = "http://services.autouplinktech.com/admin/mainoptions.cfm"
  @@comments_generator_url = "http://services.autouplinktech.com/admin/iim/navigation/home.cfm?CommentsGenerator=yes"

  @@dealer_id = ''
  @@login = ''
  @@passowrd = ''


  # Outputs an array of hashes, one for each vehicle,
  # containing :aul_id and :stock_number
  def self.set_credentials(credentials_hash)
    @@dealer_id = credentials_hash[:dealer_id]
    @@login = credentials_hash[:login]
    @@password = credentials_hash[:password]
  end

  # Outputs an array of hashes, one for each vehicle, containing :aul_id and :stock_number
  # Cache this data somewhere! Don't call it for each vehicle's aul_id !
  def self.id_matrix
    aul_scraper = AutoUplink.new
    aul_scraper.login
    aul_scraper.produce_id_matrix
  end

  # Update the comments of a single vehicle with AutoUplink id of aul_id
  def self.update_vehicle_comments(aul_id, comments)
    single_vehicle_editor(aul_id).update_comments_on_edit_page(comments)
  end

  # Retrieve the comments of a single vehicle with AutoUplink id of aul_id
  def self.retrieve_vehicle_comments(aul_id)
    single_vehicle_editor(aul_id).retrieve_comments_on_edit_page
  end


# private
  
  # returns an AutoUplink instance that is on a given vehicle's edit page
  def self.single_vehicle_editor(aul_id)
    aul_scraper = AutoUplink.new
    aul_scraper.login
    aul_scraper.goto_vehicle_edit_page(aul_id)
    aul_scraper
  end

  # Create a Mechanize agent
  def initialize
    super
    @user_agent_alias = 'Mac Safari'
    @follow_meta_refresh = true
    @redirect_ok = true
  end

  # If logged in, outputs an array of hashes, one for each vehicle, 
  # containing :aul_id and :stock_number
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

  # Pulls AutoUplink id and stock number out of a table row and returns them as a hash
  def id_hash_from_row (vehicle_row)
    vehicle_entries = vehicle_row.search("td")
    {:aul_id => Sanitize.clean(vehicle_entries[0].to_s).strip, :stock_number => Sanitize.clean(vehicle_entries[1].to_s).strip}
  end

  # Determines if a AutoUplink instance is on the main menu page or not
  def on_main_menu?
    self.page.search('meta').to_s.include?("http://services.autouplinktech.com/admin/mainoptions.cfm")
  end

  # Login to Auto Uplink
  def login
    begin
      self.get(@@login_url)
      form = self.page.forms.first
      form.uid = @@login
      form.pid = @@password
      self.submit(form)
    rescue StandardError => e
      logger = Logger.new(STDERR)
      logger.error("Could not log into AutoUplink: #{e.message}")
      return false
    end
  end

  def goto_vehicle_edit_page(aul_id)
    self.get("http://services.autouplinktech.com/admin/iim/InventoryManagement/UsedVeh.cfm?VehicleID=#{aul_id}&Edit=Yes&DealerID=#{@@dealer_id}")
  end

  def update_comments_on_edit_page(comments)
    form = self.page.forms.first
    form['DealerOptionBox'] = comments
    self.submit(form)
  end

  def retrieve_comments_on_edit_page
    form = self.page.forms.first
    form['DealerOptionBox']
  end


end