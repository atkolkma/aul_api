module Navigate

  LOGIN_URL = "http://services.autouplinktech.com/login.cfm"
  LOGOUT_URL = "http://services.autouplinktech.com/logout.cfm"
  MAIN_MENU_URL = "http://services.autouplinktech.com/admin/mainoptions.cfm"
  COMMENTS_GENERATOR_URL = "http://services.autouplinktech.com/admin/iim/navigation/home.cfm?CommentsGenerator=yes"

  @@dealer_id = ''
  @@login = ''
  @@password = ''


  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Outputs an array of hashes, one for each vehicle,
    # containing :aul_id and :stock_number
    def set_credentials(credentials_hash)
      @@dealer_id = credentials_hash[:dealer_id]
      @@login = credentials_hash[:login]
      @@password = credentials_hash[:password]
    end

    def dealer_id
      @@dealer_id
    end

    def login
      @@login
    end

    def password
      @@password
    end

  end

  # Login to Auto Uplink
  def login
    begin
      self.get(LOGIN_URL)
      form = self.page.forms.first
      form.uid = AutoUplink.login
      form.pid = AutoUplink.password
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

  # Determines if a AutoUplink instance is on the main menu page or not
  def on_main_menu?
    self.page.search('meta').to_s.include?(MAIN_MENU_URL)
  end

end