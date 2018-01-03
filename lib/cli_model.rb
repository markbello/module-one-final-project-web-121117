class CommandLineInterface

  def greet
    puts "Hello! Would you like to search by Movie or Location? (M or L)"
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
    city_name_array = city_name.split(" ")
    Location.create(city_name: city_name, country_name: country_name)

    if country_name == "usa"
        puts "Enter State"

        state_name = gets.chomp
        state_name_array = state_name.split(" ")

        full_location_name = city_name_array.join(",%20") + ",%20" + state_name_array.join(",%20") + ",%20USA"
        # new_state_name = state_name_array.join(",%20")
        html_by_input_location = open("http://www.imdb.com/search/title?locations=#{full_location_name}&ref_=ttloc_loc_2")
          # create_location_row
        # new_location.state_name = state_name

      else
        foreign_location_name = "#{city_name},+#{country_name}"
        html_by_input_location = open("http://www.imdb.com/search/title?locations=#{foreign_location_name}")
      end

  end

  def get_input_for_film
    #add method here
  end

  def run
    greet
    get_input_for_location

  end

end
