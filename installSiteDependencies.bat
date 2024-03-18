gem install bundler && gem update --system 3.5.6
gem install jekyll-remote-theme && gem install jekyll-gist
gem install "bulma-clean-theme" && gem install jekyll -v 3.8.5 && bundle init
bundle add jekyll -v 3.8.5 --skip-install
bundle exec jekyll new --force --skip-bundle .
bundle install
bundle exec jekyll serve