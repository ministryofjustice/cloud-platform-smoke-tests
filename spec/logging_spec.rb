require "spec_helper"

describe "Log collection" do
  # namespace = "smoketest-logging-#{Time.now.to_i}"
  namespace = "smoketest-logging"

  def get_pod_logs(namespace, pod_name)
    `kubectl -n #{namespace} logs #{pod_name}`
  end

  # Assumes there is only one pod in the namespace
  def get_pod_name(namespace)
    `kubectl get pods -n #{namespace} | awk 'FNR == 2 {print $1}'`.chomp
  end

  before(:all) do
    create_namespace(namespace)
    create_job(namespace, "spec/fixtures/logging-job.yaml.erb", "smoketest-logging-job")
  end

  after(:all) do
    delete_namespace(namespace)
  end

  it "logs to elasticsearch" do
    pod_name = get_pod_name(namespace)
    json = get_pod_logs(namespace, pod_name)
    hash = JSON.parse(json)
    total_hits = hash.fetch("hits").fetch("total")
    expect(total_hits).to be > 0
  end

end
