def create_namespace(namespace)
  `kubectl create namespace #{namespace} 2>/dev/null`
end

def delete_deployment(namespace, deployment)
  `kubectl -n #{namespace} delete deployment #{deployment} 2>/dev/null`
end

def apply_template_file(args)
  namespace = args.fetch(:namespace)
  file = args.fetch(:file)
  binding = args.fetch(:binding)

  renderer = ERB.new(File.read file)
  yaml = renderer.result(binding)

  `kubectl -n #{namespace} apply -f - <<EOF\n#{yaml}\nEOF\n`
end
