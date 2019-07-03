require 'spec_helper'

describe "nginx ingress" do
  let(:namespace) { 'ingress-smoketest' }
  let(:cluster_domain) { "apps.live-1.cloud-platform.service.justice.gov.uk" }
  let(:url) { "https://ingress-smoketest.#{cluster_domain}" }

  after do
    delete_deployment(namespace, 'ingress-smoketest-app')
  end

  context "when ingress is not deployed" do
    it "fails http get" do
      expect {
        open(url)
      }.to raise_error(OpenURI::HTTPError)
    end
  end

  context "when ingress is deployed" do
    before do
      create_namespace(namespace)
      sleep 3
      host = 'ingress-smoketest.apps.live-1.cloud-platform.service.justice.gov.uk'
      apply_template_file(
        namespace: namespace,
        file: 'spec/fixtures/ingress-smoketest.yaml.erb',
        binding: binding()
      )
      sleep 3
    end

    it "returns 200 for http get" do
      result = open(url)
      expect(result.status).to eq(["200", "OK"])
    end
  end
end
