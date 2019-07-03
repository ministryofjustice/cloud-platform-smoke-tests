require 'spec_helper'

describe "namespace" do

  def can_i_get(type, team, namespace = "kube-system")
    `kubectl auth can-i get #{type} --namespace #{namespace} --as test --as-group github:#{team} --as-group system:authenticated`.chomp
  end

  it "allows webops to access namespace" do
    result = can_i_get "namespace", "webops"
    expect(result).to eq("yes")
  end
  
  it "does not allow non-webops to access namespace" do
    result = can_i_get "namespace", "not-webops"
    expect(result).to eq("no")
  end

  it "allows webops to access pods" do
    result = can_i_get "pod", "webops"
    expect(result).to eq("yes")
  end
  
  it "does not allow non-webops to access pods" do
    result = can_i_get "pod", "not-webops"
    expect(result).to eq("no")
  end
  
  it "allows non-webops to access pods" do
    result = can_i_get "pod", "offender-management", "offender-management-staging"
    expect(result).to eq("yes")
  end
  
  it "allows non-webops to access namespace" do
    result = can_i_get "namespace", "offender-management", "offender-management-staging"
    expect(result).to eq("yes")
  end
end
