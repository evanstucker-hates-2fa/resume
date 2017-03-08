#!/usr/bin/env ruby

def decrypt(encrypted_base64)
  encrypted = Base64.decode64(encrypted_base64)
  decryptor = OpenSSL::Cipher.new $cipher
  decryptor.decrypt
  decryptor.pkcs5_keyivgen $pass_phrase, $salt
  decrypted = decryptor.update encrypted
  decrypted << decryptor.final
  return decrypted
end

require 'yaml'
require 'openssl'
require 'base64'

$cipher = 'AES-256-CBC'
$salt = '8 octets'

print "Pass phrase: "
$pass_phrase = gets.strip

resume = YAML.load_file('encrypted_resume.yaml')

resume['experience'].each do |job|
  # starting_compensation
  decrypted = decrypt(job['starting_compensation'])
  job['starting_compensation'] = decrypted

  # ending_compensation
  decrypted = decrypt(job['ending_compensation'])
  job['ending_compensation'] = decrypted
end

f = File.new('decrypted_resume.yaml', 'w+')
f.write(resume.to_yaml)
f.close
