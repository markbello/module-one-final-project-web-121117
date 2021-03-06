require 'pry'
require './states.rb'

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
    else
      puts "Invalid entry! Please enter F or L"
      greet
    end

  end

  def get_input_for_location
    input_location = {}
    puts "Please provide the name of the country:"
    input_location[:country_name] = gets.chomp.upcase
    puts "Enter City Name"
    input_location[:city_name] = gets.chomp
    if input_location[:country_name] == "USA"
      puts "Enter State"
      state_input = gets.chomp
      found_state = downcased_states_array.find do |state|
        state.include?(state_input.downcase)
      end
      valid_state = found_state[1].split(" ").map{|word| word.capitalize}.join(" ")
      input_location[:state_name] = valid_state
      binding.pry
    else
      input_location[:country_name] = input_location[:country_name].split(" ").map{|word| word.capitalize}.join(" ")
    end
    input_location
    url = location_url_creator(input_location)
    url.slice!("http://www.imdb.com")
    input_location[:link] = url
    if input_location[:state] == nil
      input_location[:name] = "#{input_location[:city_name]}, #{input_location[:country_name]}"
    else
      input_location[:name] = "#{input_location[:city_name]}, #{input_location[:state_name]}, #{input_location[:country_name]}"
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

  def location_url_creator(location_hash)
    city_name_array = location_hash[:city_name].split(" ")
    country_name_array = location_hash[:country_name].split(" ")
    if location_hash[:state_name]
      state_name_array = location_hash[:state_name].split(" ")
      full_location_html = "/title?locations=#{city_name_array.join(",%20")},%20#{state_name_array.join("%20")},%20USA"

    else
      foreign_location_name = "#{location_hash[:city_name]},+#{location_hash[:country_name]}"
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
  end

  def get_location_seeds_by_film_name(film_instance)

    location_hash_array = []
    url = "http://www.imdb.com" + film_instance[:link] + "locations?ref_=tt_dt_dt"
    # binding.pry
    html_by_location = open(url)
    location_doc = Nokogiri::HTML(html_by_location)
    location_data = location_doc.css("#filming_locations_content")

    location_data.css("div.soda > dt a").each do |location_item|
      location_hash = {}
      location_hash[:name] = location_item.text.chomp
      short_link = location_item.attributes["href"].value
      link_ending = /\&ref.*/.match(short_link)[0]

      short_link.slice!(link_ending)
      location_hash[:link] = short_link
      location_hash_array << location_hash
      split_location_item = location_hash[:name].split(", ")

      location_hash[:city_name] = split_location_item[-3]
      location_hash[:state_name] = split_location_item[-2]
      location_hash[:country_name] = split_location_item[-1]

      location_hash_array << location_hash
    end
    location_hash_array
  end

  def get_film_seeds_by_location(url)
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

      new_film = Film.find_or_create_by(smaller_film_hash)
      new_film.locations << location
    end
  end

  def create_location_entries_from_scrape(location_hash_array, film)
    location_hash_array.each do |location_hash|
      new_location = Location.find_or_create_by(location_hash)
      new_location.films << film
    end
  end

  def display_locations_by_film(film_instance)
    film_name = film_instance[:name]
    film_locations = film_instance.locations.all.map{|film_location| film_location[:name]}
    system("clear")

    output_message = "Locations for #{film_name} are:"
    puts output_message
    output_message.length.times {print "-"}
    puts ""
    film_locations.each { |film_location| puts film_location}
  end

  def display_films_by_location(location_instance)
    location_name = location_instance[:name]
    films_based_on_location = location_instance.films.all.map{|film| film[:name]}
    system("clear")
    output_message = "Films shot in #{location_name} are:"
    puts output_message
    output_message.length.times {print "-"}
    puts ""
    films_based_on_location.each { |film_name| puts film_name }
  end

  def run
    new_instance = greet
    if new_instance.is_a?(Location)
      if new_instance.films.count == 0
        location_url = location_url_creator(new_instance)
        scraped_film_hash_array = get_film_seeds_by_location(location_url)
        create_film_entries_from_scrape(scraped_film_hash_array, new_instance)
      end
      display_films_by_location(new_instance)
    else
      film_name_user_input = new_instance
      name_formatted_for_url = film_url_creator(film_name_user_input)
      film_hash = get_film_hash_by_name(name_formatted_for_url)
      film_instance = handle_film_input(film_hash)

      if film_instance.locations.count == 0
        location_hash_array = get_location_seeds_by_film_name(film_instance)
        create_location_entries_from_scrape(location_hash_array.uniq, film_instance)
      end
        display_locations_by_film(film_instance)
    end
  end
end
