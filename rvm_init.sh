# Run as regular user
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
unset rvm_path
unset GEM_HOME
\curl -sSL https://get.rvm.io | bash -s stable
wget https://github.com/ruby/ruby/commit/801e1fe46d83c856844ba18ae4751478c59af0d1.diff -O openssl.patch
rvm install --patch ./openssl.patch 2.1.5
gem install chef
gem install knife-solo_data_bag

