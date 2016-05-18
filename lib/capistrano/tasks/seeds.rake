namespace :seeds do
  desc "Reload seeds from scratch"
  task :reload do
    on roles(:app) do
      within current_path do
        with rails_env: :prestage do
          rake "db:schema:load"
          rake "db:seed"
        end
      end
    end
  end
end
