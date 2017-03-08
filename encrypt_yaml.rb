#!/usr/bin/env ruby

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
  encrypted_base64 = encrypt(job['starting_compensation'])
  job['starting_compensation'] = encrypted_base64

  # ending_compensation
  encrypted_base64 = encrypt(job['ending_compensation'])
  job['ending_compensation'] = encrypted_base64
end

f = File.new('encrypted_resume.yaml', 'w+')
f.write(resume.to_yaml)
f.close
