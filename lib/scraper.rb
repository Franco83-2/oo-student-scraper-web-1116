require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
      html = File.read(index_url)
      learnco = Nokogiri::HTML(html)
      learnco.css("div.student-card a").map do |student|
       {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => "./fixtures/student-site/" + student.attr('href')
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile = Nokogiri::HTML(html)
    vitalinfo_hash = {}
    vitalinfo_hash[:bio]= profile.css(".description-holder p").text
    vitalinfo_hash[:profile_quote]= profile.css(".profile-quote").text
    social = profile.css(".social-icon-container a").map { |link| link.attr('href')}
      social.each do |link|
        if link.include?("linkedin")
          vitalinfo_hash[:linkedin] = link
        elsif link.include?("twitter")
          vitalinfo_hash[:twitter] = link
        elsif link.include?("github")
          vitalinfo_hash[:github] = link
        else
          vitalinfo_hash[:blog] = link
        end
      end
    vitalinfo_hash
  end

end