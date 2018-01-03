require 'pry'

class CommandLineInterface


  def imdb_search_prefix
    "http://www.imdb.com/search"
  end

  def greet
    puts "Hello! Would you like to search by film or location? (f or l)"
    user_input = gets.chomp.downcase

    if user_input == "f"
      get_input_for_film
    elsif user_input == "l"
      get_input_for_location
    else puts "Please enter f or m"
    end

  end

  def get_input_for_location

    puts "Please provide the name of the country:"
    country_name = gets.chomp.downcase
    puts "Enter City Name"
    city_name = gets.chomp
    new_location= Location.create(city_name: city_name, country_name: country_name)

    if country_name == "usa"
        puts "Enter State"
        state_name = gets.chomp
        new_location.state_name = state_name
    end
    new_location
  end

  def get_input_for_film
    puts "Please enter a movie title:"
    user_input = gets.chomp
    new_movie = Film.create(name: user_input)
    puts new_movie.name
  end

  def location_html_creator(location_instance)
    puts "running location html"
    city_name_array = location_instance.city_name.split(" ")
    country_name_array = location_instance.country_name.split(" ")
    if location_instance.state_name
      state_name_array = location_instance.state_name.split(" ")
      full_location_html = "/title?locations=#{city_name_array.join(",%20")},%20#{state_name_array.join(",%20")},%20USA"

    else
      #need to account for names with two words
    foreign_location_name = "#{location_instance.city_name},+#{location_instance.country_name}"
    full_location_html = "/title?locations=#{foreign_location_name}"

    end
    return_html = imdb_search_prefix + full_location_html
    # puts return_html
    return_html
  end

  def scrape_films_given_location(html)
    html_by_location = open(html)
    location_doc = Nokogiri::HTML(html_by_location)
    movie_array = location_doc.css("div.lister-list > div.lister-item").map {|location_item| location_item.css("div.lister-item-content > h3 a").text}
    puts movie_array
  end

  def get_film_title_link_by_name
    html = open('http://www.imdb.com/find?ref_=nv_sr_fn&q=death+wish&s=tt')
    doc = Nokogiri::HTML(html)
    film = doc.css("tabl.findList tr")[0]
    puts film
  end

  def get_film_seeds_by_location(url)
    puts "running get film seeds method #{url}"
    film_hash_array = []
    # html_by_location = open("http://www.imdb.com/search/title?locations=Los%20Angeles,%20California,%20USA&ref_=tt_dt_dt")
    html_by_location = open(url)
    location_doc = Nokogiri::HTML(html_by_location)
    location_data = location_doc.css("div.lister-list > div.lister-item")
    location_data.each do |location_item|
      film_hash = {}

      film_hash[:name] = location_item.css("div.lister-item-content > h3 a").text

      film_year = /\d{4}/.match(location_item.css("div.lister-item-content > h3 a + span").text)
      film_year.class == MatchData ? film_year = film_year[0] : film_year = "Not Listed"
      film_hash[:year] = film_year

      film_people = location_item.css("div.lister-item-content > div.ratings-bar + p.text-muted + p a").map do |name|
        person_hash = {}
        person_hash[:name] = name.text
        link = name.attributes["href"].value
        person_hash[:link] = link
        person_hash
      end

      film_hash[:director] = film_people[0]
      film_people.shift
      film_hash[:stars] = film_people

      film_imdb_id = location_item.css("div.lister-item-content > h3.lister-item-header a")[0].attributes["href"].value
      film_hash[:link] = film_imdb_id
      film_hash_array << film_hash
    end
    puts film_hash_array
    film_hash_array
  end
  def create_film_entries_from_scrape(scrape_array)
    scrape_array.each do |movie_hash|
      Film.create(name: movie_hash[:name], year: movie_hash[:year])
    end
  end


    def api_location_given_film

    end



  def run
    new_instance = greet
    # puts new_instance
    if new_instance.is_a?(Location)

      location_html = location_html_creator(new_instance)
      # scrape_array = scrape_films_given_location(location_html)


      scraped_movie_array = get_film_seeds_by_location(location_html)
      create_film_entries_from_scrape(scraped_movie_array)



    else


    end


  end

end
