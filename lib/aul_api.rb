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

  include ExportData
  extend ExportData::ClassMethods

  # Create a Mechanize agent
  def initialize
    super
    @user_agent_alias = 'Mac Safari'
    @follow_meta_refresh = true
    @redirect_ok = true
  end

end