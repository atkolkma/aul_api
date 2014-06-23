require 'aul_api'

describe AutoUplink do

	it "is a subclass of Mechanize" do
		expect(AutoUplink.new.redirect_ok = true).to_not raise_exception
	end

end