spec = Gem::Specification.find_by_name 'deploy_mate'
load "#{spec.gem_dir}/deploy_mate/tasks/deploy_mate.rake"