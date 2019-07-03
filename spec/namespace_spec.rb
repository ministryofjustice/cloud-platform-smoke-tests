require "spec_helper"

describe "namespace" do
  it "allows webops to access namespace" do
    result = `kubectl auth can-i get namespace --namespace kube-system --as test --as-group github:webops --as-group system:authenticated`.chomp
    expect(result).to eq("yes")
  end
  it "allows webops to access pods"

end
