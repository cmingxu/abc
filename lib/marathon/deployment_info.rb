# This class represents a Marathon Deployment information.
# It is returned by asynchronious deployment calls.
class Marathon::DeploymentInfo < Marathon::Base

  RECHECK_INTERVAL = 3

  # Create a new deployment info object.
  # ++hash++: Hash returned by API, including 'deploymentId' and 'version'
  # ++marathon_instance++: MarathonInstance holding a connection to marathon
  def initialize(hash, marathon_instance = Marathon.singleton)
    super(hash, %w[deploymentId version])
    raise Marathon::Error::ArgumentError, 'version must not be nil' unless version
    @marathon_instance = marathon_instance
  end

  # Wait for a deployment to finish.
  # ++timeout++: Timeout in seconds.
  def wait(timeout = 60)
    Timeout::timeout(timeout) do
      deployments = nil
      while deployments.nil? or deployments.any? { |e| e.id == deploymentId } do
        sleep(RECHECK_INTERVAL)
        deployments = @marathon_instance.deployments.list
      end
    end
  end

  def to_s
    if deploymentId
      "Marathon::DeploymentInfo { :version => #{version} :deploymentId => #{deploymentId} }"
    else
      "Marathon::DeploymentInfo { :version => #{version} }"
    end
  end

end
