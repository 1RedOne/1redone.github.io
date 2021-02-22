gem install bundler
gem install jekyll -v 3.8.5
bundle init
bundle add jekyll -v 3.8.5 --skip-install
bundle exec jekyll new --force --skip-bundle .
bundle install
bundle exec jekyll serve