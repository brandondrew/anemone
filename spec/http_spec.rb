require File.dirname(__FILE__) + '/spec_helper'

module Anemone
  describe HTTP do

    it "should return response for GET request" do
      page = FakePage.new('GET_request')

      response = HTTP.get(URI(page.url))
      response[0].body.should == "<html><body></body></html>"
    end

    it "should return response for POST request" do
      page = FakePage.new('POST_request', :method => :post)

      response = HTTP.post(URI(page.url), 'query=value')
      response[0].body.should == "<html><body></body></html>"
    end
  end
end