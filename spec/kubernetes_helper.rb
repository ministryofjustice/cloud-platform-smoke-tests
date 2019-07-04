def create_namespace(namespace)
  unless namespace_exists?(namespace)
    `kubectl create namespace #{namespace}`

    10.times do
      break if namespace_exists?(namespace)
      sleep 1
    end
  end
end

def namespace_exists?(namespace)
  system("kubectl get namespace #{namespace} > /dev/null 2>&1")
end

def delete_namespace(namespace)
  `kubectl delete namespace #{namespace}`
end

def delete_deployment(namespace, deployment)
  `kubectl -n #{namespace} delete deployment #{deployment}`
end

def apply_template_file(args)
  namespace = args.fetch(:namespace)
  file = args.fetch(:file)
  binding = args.fetch(:binding)

  renderer = ERB.new(File.read(file))
  yaml = renderer.result(binding)

  apply_yaml(namespace, yaml)
end

def apply_yaml_file(args)
  namespace = args.fetch(:namespace)
  file = args.fetch(:file)
  apply_yaml(namespace, File.read(file))
end

def apply_yaml(namespace, yaml)
  `kubectl -n #{namespace} apply -f - <<EOF\n#{yaml}\nEOF\n`
end

def wait_for(namespace, type, name, seconds = 10)
  seconds.times do
    break if object_exists?(namespace, type, name)
    sleep 1
  end
end

def object_exists?(namespace, type, name)
  system("kubectl -n #{namespace} get #{type} #{name} > /dev/null")
end
