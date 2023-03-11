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

require 'date'
require 'yaml'
require 'openssl'
require 'base64'

$cipher = 'AES-256-CBC'
$salt = '8 octets'

print "Pass phrase: "
$pass_phrase = gets.strip

resume = YAML.load_file(
  'encrypted_resume.yaml',
  permitted_classes: [Date]
)

resume['experience'].each do |job|
  # starting_compensation
  unless job['starting_compensation'].nil?
    decrypted = decrypt(job['starting_compensation'])
    job['starting_compensation'] = decrypted
  end

  # ending_compensation
  unless job['ending_compensation'].nil?
    decrypted = decrypt(job['ending_compensation'])
    job['ending_compensation'] = decrypted
  end
end

f = File.new('decrypted_resume.yaml', 'w+')
f.write(resume.to_yaml)
f.close
