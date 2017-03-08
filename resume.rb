#!/usr/bin/env ruby

# Obligatory TODOs:
# * Fix broken squiggly HEREDOC output in the experience loop.

require 'yaml'

resume = YAML.load_file('decrypted_resume.yaml')

# HTML Head and Style
output = <<~END
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <style>
        a {
          color: black;
          text-decoration: none;
        }
        a:hover {
          color: blue;
          text-decoration: underline;
        }
        body {
          font-family: sans-serif;
        }
        li {
          list-style: none; /* IE displays bullets differently */
        }
        p {
          padding-left: 2%;
          padding-right: 2%;
        }
        ul {
          padding-left: 2%;
          padding-right: 2%;
        }
        .bold {
          font-weight: bold;
        }
        .clear {
          clear: both;
        }
        .contact {
          text-align: center;
        }
        .generated {
          color: #888888;
          font-style: italic;
          text-align: center;
        }
        .headline {
          background-color: #e0e0e0;
          border: 2px solid #0e0e0e;
          font-weight: bold;
          font-size: 110%;
          margin: 6px 0px 6px 0px;
          padding: 4px 4px 4px 4px;
          text-align: center;
        }
        .left {
          float: left;
          font-weight: bold;
        }
        .right {
          float: right;
          font-weight: bold;
          text-align: right;
        }
      </style>
      <title>#{resume['contact']['name']}'s Resume</title>
    </head>
    <body>
  END

# Contact Info and Biography
output << <<~END
      <div class="contact">
        <span class="bold">#{resume['contact']['name']}</span><br>
        <a href="tel:#{resume['contact']['phone'].gsub(/\s+/, "")}">#{resume['contact']['phone']}</a><br>
        <a href="mailto:#{resume['contact']['email']}">#{resume['contact']['email']}</a>
      </div>
      <div class="headline">Biography</div>
      <span>#{resume['biography']}</span>
  END

# Experience
output << "    <div class=\"headline\">Experience</div>\n"
resume['experience'].each do |job|
  if job['tags'].to_s.include? 'current'
    if job['tags'].to_s.include? 'story_time'
      description_entity = 'p'
    else
      description_entity = 'li'
    end
    if job['end_date'].nil?
      duration = "#{job['start_date']} to Present"
      job['end_date'] = DateTime.now
    else
      duration = "#{job['start_date']} to #{job['end_date']}"
    end
    years = "%0.2f" % ((job['end_date'] - job['start_date']).to_f / 365)
    # LLLLLEEEEEEERRROOOOOOOOYYYYYYNNNJEEEENNKKIINNSSS!
    if years.to_s.chars.last(2).join == '33'
      duration << " (<a href=\"https://www.youtube.com/watch?v=hooKVstzbz0\" title=\"repeating of course\">#{years}</a> years)"
    else
      duration << " (#{years} years)"
    end
    output << <<~END
          <div class="left">
            #{job['title']} at <a href="#{job['url']}">#{job['company']}</a> (#{job['location']})
          </div>
          <div class="right">
            #{duration}
          </div>
          <div class="clear">
      END
    if description_entity == 'li'
      output << "      <ul>\n"
    end
    job['description'].each do |item|
      output << "      <#{description_entity}>#{item}</#{description_entity}>\n"
    end
    if description_entity == 'li'
      output << "      </ul>\n"
    end
    output << "    </div>\n"
  end
end

# Education
output << "    <div class=\"headline\">Education</div>\n"
resume['education'].each do |institution|
  if institution['tags'].to_s.include? 'college'
    output << <<~END
          <div class="left">
            <a href="#{institution['url']}">#{institution['name']}</a>
          </div>
          <div class="right">
            #{institution['degree']} in #{institution['major']}
          </div>
          <div class="clear">
            <ul>
      END
    institution['achievements'].each do |cheevo|
      output << "      <li>#{cheevo}</li>\n"
    end
    output << <<~END
            </ul>
          </div>
      END
  end
end

output << <<~END
      <div class="generated">This resume isn't a Word doc or a PDF - it's code! You can see the source here: <a class="generated" href="https://gitlab.com/evanstucker/resume">https://gitlab.com/evanstucker/resume</a></div>
    </body>
  </html>
  END

file_name = "#{resume['contact']['name']}'s Resume.html"

f = File.new("#{file_name}", 'w+')
f.write(output)
f.close
system( "tidy -i -m -w \"#{file_name}\"" )
