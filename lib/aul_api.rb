require 'mechanize'
require 'logger'
require 'sanitize'
require 'auto_uplink/navigate'
require 'auto_uplink/import_data'
require 'auto_uplink/export_data'

class AutoUplink < Mechanize

  include Navigate
  extend Navigate::ClassMethods
  include ImportData
  extend ImportData::ClassMethods

  # Outputs an array of hashes, one for each vehicle, containing :aul_id and :stock_number
  # Cache this data somewhere! Don't call it for each vehicle's aul_id !
  def self.id_matrix
    aul_scraper = AutoUplink.new
    aul_scraper.login
    aul_scraper.produce_id_matrix
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
    self.get(Navigate::COMMENTS_GENERATOR_URL)
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

  # returns an AutoUplink instance that is on a given vehicle's edit page
  def self.single_vehicle_editor(aul_id)
    aul_scraper = AutoUplink.new
    aul_scraper.login
    aul_scraper.goto_vehicle_edit_page(aul_id)
    aul_scraper
  end

  # Update the comments of a single vehicle with AutoUplink id of aul_id
  def self.update_vehicle_comments(aul_id, comments)
    single_vehicle_editor(aul_id).update_comments_on_edit_page(comments)
  end

  # Retrieve the comments of a single vehicle with AutoUplink id of aul_id
  def self.retrieve_vehicle_comments(aul_id)
    single_vehicle_editor(aul_id).retrieve_comments_on_edit_page
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