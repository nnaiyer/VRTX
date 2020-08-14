require 'selenium-webdriver'
require 'test-unit'

def alert_present?
  begin
    @driver.switch_to.alert
    true
  rescue
    return false
  end
end


class VoterStatus < Test::Unit::TestCase
    def setup

###########################################################
# => USER INPUT INFORMATION HERE

      ### !!! WRITE EVERYTHING INSIDE THE QUOTATION MARKS !!! ###

      ### Write all text in all caps
      @first_name = ""
      @last_name = ""
      @county = ""

      ### Write date_of_birth in mm/dd/yyyy format
      @date_of_birth = ""
      @zip = ""
###########################################################


      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')


      @driver = Selenium::WebDriver.for :chrome, :options => options
      @url = "https://teamrv-mvp.sos.texas.gov/MVP/mvp.do"
      @driver.manage.timeouts.implicit_wait = 30
    end


    def test_registrationCheck
        @driver.get(@url)
        @driver.find_element(:id, 'selType').click

        dropdown_list = @driver.find_element(:id, 'selType')
        options = dropdown_list.find_elements(tag_name: 'option')
        options.each { |option| option.click if option.text == 'Name, County, Date of Birth' }

        @driver.find_element(:id, 'firstName').send_keys(@first_name)
        @driver.find_element(:id, 'lastName').send_keys(@last_name)
        @driver.find_element(:id, 'dob').send_keys(@date_of_birth)
        @driver.find_element(:id, 'adZip5').send_keys(@zip)

        dropdown_list = @driver.find_element(:id, 'county')
        options = dropdown_list.find_elements(tag_name: 'option')
        options.each { |option| option.click if option.text == @county.upcase }

        @driver.find_element(:id, 'VALIDBTN').click

        cancelTest = 0
        if alert_present?
          alert_popup = @driver.switch_to.alert
          print "Website Alert: #{alert_popup.text}\n\n"
          @driver.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoAlertOpenError
          cancelTest = 1
        end

        if cancelTest.equal?(0)
          elem = @driver.find_element(:css, 'span:nth-child(12)').text
          p (elem[14..-1] == "ACTIVE" ? "Your voter status is active!" : "Your voter status is inactive - Check on your registration!")
        else
          p "You may have inputted your information incorrectly. Please look over your details again."
        end

end
end

