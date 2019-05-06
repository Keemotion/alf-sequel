source 'http://rubygems.org'

gem "rake", "~> 10.1"
gem "rspec", "~> 2.14"

group :runtime do
  gem "sequel", "~> 5.19"

  gem "alf-core", git: "https://github.com/Keemotion/alf-core.git"
  gem "alf-sql", git: "https://github.com/Keemotion/alf-sql.git"
end

group :test do
  gem "sqlite3", "~> 1.3",      :platforms => ['mri', 'rbx']
  gem "jdbc-sqlite3", "~> 3.7", :platforms => ['jruby']
  gem "pg"
end
