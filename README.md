# Chef Cookbooks
This is where I store my private chef cookbooks. Most of 'em won't be of any use
for somebody else. 

## Requirements
* rvm

## How to use in local mode (Chef Zero)
* bundle install
* bundle exec librarian-chef install --clean
* rvmsudo bundle exec chef-client -z -c ~/client.rb
* bundle exec knife solo data bag edit production irssi --secret-file
<encrypted_data_bag_secret>

