require 'active_support'
require 'openssl'
a=  OpenSSL::PKCS5.pbkdf2_hmac_sha1(@secret, salt, @iterations, key_size)

puts a