```
_______/\\\\\________/\\\\____________/\\\\______/\\\\\\\\\\\\_        
 _____/\\\///\\\_____\/\\\\\\________/\\\\\\____/\\\//////////__       
  ___/\\\/__\///\\\___\/\\\//\\\____/\\\//\\\___/\\\_____________      
   __/\\\______\//\\\__\/\\\\///\\\/\\\/_\/\\\__\/\\\____/\\\\\\\_     
    _\/\\\_______\/\\\__\/\\\__\///\\\/___\/\\\__\/\\\___\/////\\\_    
     _\//\\\______/\\\___\/\\\____\///_____\/\\\__\/\\\_______\/\\\_   
      __\///\\\__/\\\_____\/\\\_____________\/\\\__\/\\\_______\/\\\_  
       ____\///\\\\\/______\/\\\_____________\/\\\__\//\\\\\\\\\\\\/__ 
        ______\/////________\///______________\///____\////////////____
```

You're here reading my source code! That's fantastic!

For as long as I can remember, my resume has been this terrifying XML document that used XSL transformations to convert it to an XHTML 1.0 file. Lotta Xs. I finally decided to upgrade it. Now I'm using an easy-to-read YAML file for data, and some basic Ruby code to generate an HTML5 file. One might ask why I generate it using code at all. My answer to that is that I am a **systems administrator**! I automate everything! You can search and replace in a doc, but if you decide to change the layout, it's a hassle. With this code, I can just change the template and re-generate it...

But, if I'm being completely honest, I just like to write code and this was as good an excuse as any to do it...

# Files

| File | Description |
| -------- | -------- |
| [.gitignore](.gitignore) | Ignores any decrypted files. |
| [Evans Tucker's Resume.html](Evans Tucker's Resume.html) | The output of this process. |
| [README.md](README.md) | This. |
| [decrypt_yaml.rb](decrypt_yaml.rb) | Decrypts the encrypted_resume.yaml file. |
| decrypted_resume.yaml | Not in this repo, because it contains secret info. This is what resume.rb uses as input. |
| [encrypt_yaml.rb](encrypt_yaml.rb) | Encrypts the decrypted_resume.yaml file. |
| [encrypted_resume.yaml](encrypted_resume.yaml) | Resume with sensitive fields encrypted. |
| [resume.rb](resume.rb) | Reads YAML, outputs HTML. |

# Process

1. Decrypt the YAML file: ```decrypt_yaml.rb```
2. Update decrypted_resume.yaml.
3. Encrypt it: ```encrypt_yaml.rb```
4. Generate the resume: ```resume.rb```
5. Does it look good? Yeah, it looks reeeaaalll good.
6. Commit it.
7. Get hired by a really savvy person - perhaps the person reading this right now.
8. Have a fulfilling career.
9. Retire.
10. Walk the Earth.

Thanks to http://patorjk.com/software/taag/ for the awesome ASCII art generator.
