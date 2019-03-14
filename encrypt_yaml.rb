#!/usr/bin/env ruby

# This is kinda dumb, but it works for now.
#
# NOTE: The ending_compensation has to be non-empty. This doesn't really make
# sense. I should make it make sense one day.

def encrypt(plaintext)
  encryptor = OpenSSL::Cipher.new $cipher
  encryptor.encrypt
  encryptor.pkcs5_keyivgen $pass_phrase, $salt
  encrypted = encryptor.update plaintext
  encrypted << encryptor.final
  encrypted_base64 = Base64.encode64(encrypted).strip
  return encrypted_base64
end

require 'yaml'
require 'openssl'
require 'base64'

$cipher = 'AES-256-CBC'
$salt = '8 octets'

print "Pass phrase: "
$pass_phrase = gets.strip

resume = YAML.load_file('decrypted_resume.yaml')

resume['experience'].each do |job|
  # starting_compensation
  unless job['starting_compensation'].nil?
    encrypted_base64 = encrypt(job['starting_compensation'])
    job['starting_compensation'] = encrypted_base64
  end

  # ending_compensation
  unless job['ending_compensation'].nil?
    encrypted_base64 = encrypt(job['ending_compensation'])
    job['ending_compensation'] = encrypted_base64
  end
end

f = File.new('encrypted_resume.yaml', 'w+')
f.write(resume.to_yaml)
f.close
