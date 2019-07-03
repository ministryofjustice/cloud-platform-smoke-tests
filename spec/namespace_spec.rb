require "spec_helper"

describe "namespace" do

  def can_i_get(type)
    `kubectl auth can-i get #{type} --namespace kube-system --as test --as-group github:webops --as-group system:authenticated`.chomp
  end

  it "allows webops to access namespace" do
    result = can_i_get "namespace"
    expect(result).to eq("yes")
  end

  it "allows webops to access pods" do
    result = can_i_get "pod"
    expect(result).to eq("yes")
  end
end
