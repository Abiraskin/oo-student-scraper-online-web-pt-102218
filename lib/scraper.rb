require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css("div.roster-cards-comtainer").each do |card|
      card.css("a").each do |student|
        student_profile = "#{student.attr("href")}"
        student_location = student.css("p").text
        student_name = student.css("h4").text
        students << {name: studen_name, location: student_location, profile_url: student_profile}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map { |e| e.attribute("href").value}
    links.each do |l|
      if l.include?("linkedin")
        student[:linkedin] = l
      elsif l.include?("github")
        student[:github] = l
      elsif l.include?("twitter")
        student[:twitter] = l
      else
        student[:blog] = l
      end
    end
    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")  

    student
  end

end
