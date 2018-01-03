class CommandLineInterface

  def greet
    # determine if movie or location
    # if user wants location - call get_input_for_location
    # if user wants film - call get_input_for_film
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

  def run
    get_input_for_location

  end

end
