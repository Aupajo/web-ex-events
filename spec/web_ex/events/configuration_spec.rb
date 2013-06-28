require 'spec_helper'

describe Configuration do
  context "with all environment variables present" do
    before :each do
      ENV.stub(:[]).with("WEBEX_SITE_NAME").and_return("bakeryevents")
      ENV.stub(:[]).with("WEBEX_USERNAME").and_return("bakery")
      ENV.stub(:[]).with("WEBEX_PASSWORD").and_return("secret")
      ENV.stub(:[]).with("WEBEX_SITE_ID").and_return("358562")
      ENV.stub(:[]).with("WEBEX_PARTNER_ID").and_return("123ab")
    end
  
    it { Configuration.site_name.should == "bakeryevents" }
    it { Configuration.username.should == "bakery" }
    it { Configuration.password.should == "secret" }
    it { Configuration.site_id.should == "358562" }
    it { Configuration.partner_id.should == "123ab" }
    it { Configuration.xml_service_url.should == "https://bakeryevents.webex.com/WBXService/XMLService" }
  end
end