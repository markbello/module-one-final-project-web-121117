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
    else puts "Please enter F or L"
    end

  end

  def get_input_for_location
    input_location = {}
    puts "Please provide the name of the country:"
    input_location[:country_name] = gets.chomp.downcase
    puts "Enter City Name"
    input_location[:city_name] = gets.chomp.downcase

    if input_location[:country_name] == "usa"
        puts "Enter State"
        state_name = gets.chomp.downcase
        input_location[:state_name] = state_name
    end
    handle_location_input(input_location)
  end

  def handle_location_input(input)
    Location.find_or_create_by(input)
  end

  def get_input_for_film
    puts "Please enter a movie title:"
    input = gets.chomp
  end

  def handle_film_input(input)
    Film.find_or_create_by(input)
  end

  def location_url_creator(location_instance)
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
    return_html
  end

  def film_url_creator(film_name_user_input)
    name_formatted_for_url = film_name_user_input.split(" ").join("+")
  end

  def get_film_hash_by_name(name_formatted_for_url)
    search_result_html = open("http://www.imdb.com/find?ref_=nv_sr_fn&q=#{name_formatted_for_url}&s=tt")
    search_result_doc = Nokogiri::HTML(search_result_html)
    film_page_url = search_result_doc.css("table.findList tr a")[0].attributes["href"].value

    film_page_html = open("http://www.imdb.com#{film_page_url}")
    film_page_doc = Nokogiri::HTML(film_page_html)
    raw_film_name = film_page_doc.css("div.title_wrapper h1").text
    film_name = /.*\(/.match(raw_film_name)[0].chop.chop
    film_year = /\d{4}/.match(raw_film_name)[0]

    film_hash = {}
    film_hash[:name] = film_name
    film_hash[:year] = film_year
    film_hash[:link] = film_page_url

    film_hash[:link].slice!("?ref_=fn_tt_tt_1")

    film_hash
    # binding.pry

  end

  def get_location_seeds_by_film_name(film_instance)

    location_hash_array = []
    # shortened_url = film_instance[:link]
    # binding.pry
    # shortened_url.slice!("?ref_=fn_tt_tt_1")
    url = "http://www.imdb.com" + film_instance[:link] + "locations?ref_=tt_dt_dt"

    html_by_location = open(url)
    location_doc = Nokogiri::HTML(html_by_location)
    location_data = location_doc.css("#filming_locations_content")

    location_data.css("div.soda > dt a").each do |location_item|
      location_hash = {}
      location_hash[:name] = location_item.text.chomp
      location_hash[:link] = location_item.attributes["href"].value
      location_hash_array << location_hash
      split_location_item = location_hash[:name].split(", ")

      location_hash[:city_name] = split_location_item[-3]
      location_hash[:state_name] = split_location_item[-2]
      location_hash[:country_name] = split_location_item[-1]

      location_hash_array << location_hash
    end


    location_hash_array
    # binding.pry
  end

  def get_film_seeds_by_location(url)
    # puts "running get film seeds method #{url}"
    film_hash_array = []
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
      film_hash[:link].slice!("?ref_=adv_li_tt")
      film_hash_array << film_hash
    end
    film_hash_array
  end

  def create_film_entries_from_scrape(film_hash_array, location)
    film_hash_array.each do |film_hash|

      smaller_film_hash = {}
      smaller_film_hash[:name] = film_hash[:name]
      smaller_film_hash[:year] = film_hash[:year]
      smaller_film_hash[:link] = film_hash[:link]

      # new_film = Film.create(name: film_hash[:name], year: film_hash[:year], link: film_hash[:link])
      new_film = Film.find_or_create_by(smaller_film_hash)
      # binding.pry
      # new_film[:link] == nil ? new_film[:link] = film_hash[:link] : false
      new_film.locations << location
    end
  end

  def create_location_entries_from_scrape(location_hash_array, film)
    location_hash_array.each do |location_hash|
      new_location = Location.find_or_create_by(location_hash)
      new_location.films << film
      new_location.save
    end
  end

  def run
    new_instance = greet
    if new_instance.is_a?(Location)
      if new_instance.films.count == 0
        location_url = location_url_creator(new_instance)
        scraped_film_hash_array = get_film_seeds_by_location(location_url)
        create_film_entries_from_scrape(scraped_film_hash_array, new_instance)
      end
      # new_instance.films.all.each{|film| puts film.name }
      # binding.pry
    else
      film_name_user_input = new_instance
      name_formatted_for_url = film_url_creator(film_name_user_input)
      film_hash = get_film_hash_by_name(name_formatted_for_url)
      film_instance = handle_film_input(film_hash)
      # binding.pry
      if film_instance.locations.count == 0
        location_hash_array = get_location_seeds_by_film_name(film_instance)
        create_location_entries_from_scrape(location_hash_array.uniq, film_instance)
      end
        # binding.pry
    end
  end
end
