module ImportData

  module ClassMethods
    # returns an AutoUplink instance that is on a given vehicle's edit page
    def single_vehicle_editor(aul_id)
      aul_scraper = AutoUplink.new
      aul_scraper.login
      aul_scraper.goto_vehicle_edit_page(aul_id)
      aul_scraper
    end

    # Update the comments of a single vehicle with AutoUplink id of aul_id
    def update_vehicle_comments(aul_id, comments)
      single_vehicle_editor(aul_id).update_comments_on_edit_page(comments)
    end

  end


  def update_comments_on_edit_page(comments)
    form = self.page.forms.first
    form['DealerOptionBox'] = comments
    self.submit(form)
  end

end