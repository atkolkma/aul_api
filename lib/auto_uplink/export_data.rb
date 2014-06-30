module ExportData

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Outputs an array of hashes, one for each vehicle, containing :aul_id and :stock_number
    # Cache this data somewhere! Don't call it for each vehicle's aul_id !
    def id_matrix
      aul_scraper = AutoUplink.new
      aul_scraper.login
      aul_scraper.produce_id_matrix
    end

    # Retrieve the comments of a single vehicle with AutoUplink id of aul_id
    def retrieve_vehicle_comments(aul_id)
      single_vehicle_editor(aul_id).retrieve_comments_on_edit_page
    end

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

  def retrieve_comments_on_edit_page
    form = self.page.forms.first
    form['DealerOptionBox']
  end

end