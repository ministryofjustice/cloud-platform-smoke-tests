require "spec_helper"

describe "custom error pages" do
  context "404" do
    let(:url) do
      "https://foobar.apps.#{current_cluster}"
    end

    it "gets a 404 status" do
      expect {
        URI.open(url)
      }.to raise_error(OpenURI::HTTPError, "404 Not Found")
    end

    it "serves a custom error page" do
      begin
        URI.open(url)
      rescue OpenURI::HTTPError => e
        body = e.io.string
        # We assume that, if the page body contains this string,
        # then it's our custom error page
        expect(body).to match(/design-system.service.gov.uk/)
      end
    end
  end
end
