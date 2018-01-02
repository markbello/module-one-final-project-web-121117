class FilmLocation < ActiveRecord::Base
  belongs_to :film
  belongs_to :location

end
