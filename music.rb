# This example shows one way to set up and use a database with Ruby.

# One of the really great things about Ruby is that there is 
# lots of code written by the community and provided for free.

# One example of this is ActiveRecord, which makes 
# it easy to use databases in your programs.
require 'active_record'

# In this example we are creating a database to keep track of our music collection.
# The code below uses ActiveRecord to create an empty database, in a file called "music_database"

# ActiveRecord supports many types of database, called database engines.
# In this example I've used one called 'sqlite3', but there are many popular alternatives.
ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => "music_database"
)

# music_database is empty.
# Lets create some tables.
ActiveRecord::Schema.define do

    create_table :bands do |table|
        table.column :name, :string
    end

    create_table :albums do |table|
        table.column :title, :string
        table.column :band_id, :integer
    end

    create_table :tracks do |table|
        table.column :album_id, :integer
        table.column :track_number, :integer
        table.column :title, :string
    end

end

# Next we specify the tables and how they are related to each other.

# ActiveRecord knows about plurals - the 'Band' class will 
# look for a table called 'bands'.
class Band < ActiveRecord::Base
    has_many :albums
    
    # When you want to find tracks starting from a band, ActiveRecord will
    # look up that bands albums first, then find the tracks in those albums.
    has_many :tracks, :through => :albums
end

# Again, the plurals are understood - this will connect to the "albums" table automatically.
class Album < ActiveRecord::Base
    has_many :tracks
    belongs_to :band
end

class Track < ActiveRecord::Base
    belongs_to :album
    default_scope  { order 'album_id asc, track_number asc' }
    scope :opener, -> { where(track_number: 1)}
    def to_s
        "#{album.title} - #{track_number} - #{title}"
    end
end

# Add a record to the "bands" table
band = Band.create(:name => 'The Rolling Stones')

# Add an record to the "albums" table
album = band.albums.create(:title => 'Black and Blue')

# Add some record to the "tracks" table
album.tracks.create(:track_number => 1, :title => 'Hot Stuff')
album.tracks.create(:track_number => 2, :title => 'Hand Of Fate')
album.tracks.create(:track_number => 3, :title => 'Cherry Oh Baby ')
album.tracks.create(:track_number => 4, :title => 'Memory Motel ')
album.tracks.create(:track_number => 5, :title => 'Hey Negrita')
album.tracks.create(:track_number => 6, :title => 'Fool To Cry')
album.tracks.create(:track_number => 7, :title => 'Crazy Mama')
album.tracks.create(:track_number => 8, :title => 'Melody (Inspiration By Billy Preston)')

# Add another album
album = band.albums.create(:title => 'Sticky Fingers')
album.tracks.create(:track_number => 1, :title => 'Brown Sugar')
album.tracks.create(:track_number => 2, :title => 'Sway')
album.tracks.create(:track_number => 3, :title => 'Wild Horses')
album.tracks.create(:track_number => 4, :title => "Can't You Hear Me Knocking")
album.tracks.create(:track_number => 5, :title => 'You Gotta Move')
album.tracks.create(:track_number => 6, :title => 'Bitch')
album.tracks.create(:track_number => 7, :title => 'I Got The Blues')
album.tracks.create(:track_number => 8, :title => 'Sister Morphine')
album.tracks.create(:track_number => 9, :title => 'Dead Flowers')
album.tracks.create(:track_number => 10, :title => 'Moonlight Mile')

# Add another record to the "bands" table
band = Band.create(:name => 'Nirvana')

# Add an record to the "albums" table
album = band.albums.create(:title => 'Bleach')
album.tracks.create(:track_number => 1, :title =>  'Blew')
album.tracks.create(:track_number => 2, :title =>  'Floyd the Barber')
album.tracks.create(:track_number => 3, :title =>  'About a Girl')
album.tracks.create(:track_number => 4, :title =>  'School')
album.tracks.create(:track_number => 5, :title =>  'Love Buzz')
album.tracks.create(:track_number => 6, :title =>  'Paper Cuts')
album.tracks.create(:track_number => 7, :title =>  'Negative Creep')
album.tracks.create(:track_number => 8, :title =>  'Scoff')
album.tracks.create(:track_number => 9, :title =>  'Swap Meet')
album.tracks.create(:track_number => 10, :title => 'Mr. Moustache')
album.tracks.create(:track_number => 11, :title => 'Sifting')

# Find the rolling stones
rolling_stones = Band.where(name: "The Rolling Stones").first

puts rolling_stones.tracks.where('tracks.title like \'H%\' or tracks.title like \'M%\' ').to_sql
# Find tracks starting with 'H' or 'M', by the rolling stones
rolling_stones.tracks.where('tracks.title like \'H%\' or tracks.title like \'M%\' ').each do |track|
    puts track
end
