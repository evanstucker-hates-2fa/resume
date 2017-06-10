#!/usr/bin/env ruby

# Obligatory TODOs:
# * Fix broken squiggly HEREDOC output in the experience loop.

require 'yaml'

resume = YAML.load_file('decrypted_resume.yaml')

output = <<~END
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8">
      <script type="text/javascript">
        function calculateYears() {
          "use strict";
          var yearsElements = document.getElementsByClassName("years");
          var i;
          var startDate;
          var endDate;
          var startDateUTC;
          var endDateUTC;
          var diffInYears;
          for (i = 0; i < yearsElements.length; i += 1) {
            startDate = new Date(yearsElements[i].dataset.startDate);
            if (yearsElements[i].dataset.endDate === "") {
              endDate = new Date();
            } else {
              endDate = new Date(yearsElements[i].dataset.endDate);
            }
            // Convert Dates to milliseconds so we can do math.
            startDateUTC = Date.UTC(startDate.getFullYear(), startDate.getMonth(), startDate.getDate());
            endDateUTC = Date.UTC(endDate.getFullYear(), endDate.getMonth(), endDate.getDate());
            diffInYears = ((endDateUTC - startDateUTC) / 1000 / 60 / 60 / 24 / 365).toFixed(2);
            // LLLLLEEEEEEERRROOOOOOOOYYYYYYNNNJEEEENNKKIINNSSS!
            // Set diffInYears to something ending in ".33" to test.
            //diffInYears = 1.33
            if ( /\\.33/.test(diffInYears) ) {
              yearsElements[i].innerHTML = '(<a href="https://www.youtube.com/watch?v=hooKVstzbz0" title="... point 33 - repeating of course ...">' + diffInYears + '</a> years)';
            } else {
              yearsElements[i].textContent = " (" + diffInYears + " years)";
            }
          }
        }
      </script>
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
	/* IE displays bullets differently, so I decided to just use Unicode
             bullets at the beginning of my list items. */
        li {
          list-style: none;
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
    <body onload="calculateYears()">
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
    else
      duration = "#{job['start_date']} to #{job['end_date']}"
    end
    duration << "<span class=\"years\" data-start-date=\"#{job['start_date']}\" data-end-date=\"#{job['end_date']}\"></span>"
    output << <<~END
          <div class="left">#{job['title']} at <a href="#{job['url']}">#{job['company']}</a> (#{job['location']})</div>
          <div class="right">#{duration}</div>
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
          <div class="left"><a href="#{institution['url']}">#{institution['name']}</a></div>
          <div class="right">#{institution['degree']} in #{institution['major']}</div>
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

# Footer
output << <<~END
      <div class="generated">This resume isn't a Word doc or a PDF - it's code! You can see the source here: <a class="generated" href="https://gitlab.com/evanstucker/resume">https://gitlab.com/evanstucker/resume</a></div>
    </body>
  </html>
  END

file_name = "#{resume['contact']['name']}'s Resume.html"

f = File.new("#{file_name}", 'w+')
f.write(output)
f.close

# This mangles things, but I wish it wouldn't...
#system( "tidy -i -m -utf8 -w \"#{file_name}\"" )
