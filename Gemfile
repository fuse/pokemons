source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "rails", "~> 7.0.1"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "bootsnap", require: false
gem "dry-struct"
gem "dry-validation"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 5.1"
end
