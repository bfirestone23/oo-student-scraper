require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    student = []

    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |s|
        student_name = s.css(".student-name").text
        student_location = s.css(".student-location").text
        student_profile_url = s.attr("href").to_s
        student << {name: student_name, location: student_location, profile_url: student_profile_url}
      end
    end

    student
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    
    social_links = profile_page.css(".social-icon-container").children.css("a").collect {|l| l.attribute("href").value}
    social_links.each do |link|
      if link.include?('twitter')
        student[:twitter] = link
      elsif link.include?('github')
        student[:github] = link 
      elsif link.include?('linkedin')
        student[:linkedin] = link 
      else
        student[:blog] = link
      end
    end

    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css(".bio-content div.description-holder").text.strip if profile_page.css(".bio-content div.description-holder")

    student
  end

end

