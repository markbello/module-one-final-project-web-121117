require 'pry'

class CommandLineInterface

  def greet
    puts "Hello! Would you like to search by movie or location? (m or l)"
    user_input = gets.chomp.downcase

    if user_input == "m"
      get_input_for_film
    elsif user_input == "l"
      get_input_for_location
    else puts "Please enter M or L"
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
    city_name_array = location_instance.city_name.split(" ")
    country_name_array = location_instance.country_name.split(" ")
    if location_instance.state_name
      state_name_array = location_instance.state_name.split(" ")
      full_location_html = "http://www.imdb.com/search/title?locations=#{city_name_array.join(",%20")},%20#{state_name_array.join(",%20")},%20USA"
      puts full_location_html
    else

    # foreign_location_name = "#{city_name},+#{country_name}"
    # html_by_input_location = open("http://www.imdb.com/search/title?locations=#{foreign_location_name}")
    end

  end

  # def scrape_film_given_location
  #   html_by_input_location = open("http://www.imdb.com/search/title?locations=#{full_location_name}&ref_=ttloc_loc_2")
  # end

  def api_location_given_film

  end



  def run
    new_instance = greet
    # puts new_instance
    if new_instance.is_a?(Location)

      location_html_creator(new_instance)
      # scrape_film_given_location
    else
    end


  end

end
