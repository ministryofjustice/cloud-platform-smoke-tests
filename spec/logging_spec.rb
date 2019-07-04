require "spec_helper"

describe "Log collection", cluster: 'live-1' do
  let(:namespace) { "smoketest-logging-#{Time.now.to_i}" }

  def get_pod_logs(namespace, pod_name)
    `kubectl -n #{namespace} logs #{pod_name}`
  end

  # Get the name of the Nth pod in the namespace
  def get_pod_name(namespace, index)
    `kubectl get pods -n #{namespace} | awk 'FNR == #{index + 1} {print $1}'`.chomp
  end

  before do
    create_namespace(namespace)

    # this job just outputs 'hello world' to stdout
    create_job(namespace, "spec/fixtures/helloworld-job.yaml.erb", "smoketest-helloworld-job")

    # It takes time for the 'helloworld' job output to be shipped to elasticsearch, and there
    # is no easy way to figure out when this has/hasn't happened. This sleep seems to work
    # consistently, but it's possible it may break unexpectedly, at some point.
    sleep 60

    # this job queries elasticsearch, looking for all log data for our namespace, today
    create_job(namespace, "spec/fixtures/logging-job.yaml.erb", "smoketest-logging-job")
  end

  after do
    delete_namespace(namespace)
  end

  it "logs to elasticsearch" do
    pod_name = get_pod_name(namespace, 2) # We created 2 jobs, so the pod we want is the 2nd one
    json = get_pod_logs(namespace, pod_name) # results from the elasticsearch query
    hash = JSON.parse(json)
    total_hits = hash.fetch("hits").fetch("total")
    expect(total_hits).to be > 0 # i.e. there are some log events for our namespace
  end

end
