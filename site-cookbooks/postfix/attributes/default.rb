node.default['postfix']['server_name'] = 'mail.nostalgix.org'
node.default['postfix']['user'] = 'madhatter'
# sasl providers
# possible values are sasldb or pam
node.default['postfix']['sasl_provider'] = 'sasldb'
