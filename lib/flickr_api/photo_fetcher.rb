require 'net/http'
require 'json'

class FlickrApi::PhotoFetcher
  PHOTOS_LIMIT = 10
  # For simple setup
  API_KEY = '132f8d79762676759790db007db3cd50'.freeze
  API_URL = 'https://api.flickr.com/services/rest'.freeze

  def self.call(words)
    new(words).fetch
    @error ? { error: @error } : {}
  end

  def initialize(words)
    @words = words
    @error = nil
    @prefix = '../' if Dir.pwd.include?('bin')
  end

  def fetch
    photos = collect_user_photo_urls(@words) || []
    photos = collect_dictionary_photo_urls(photos) if photos.size < PHOTOS_LIMIT
    download(photos)
  end

  private

  def download(photos)
    puts "\nDOWNLOADING: "
    threads = []
    photos.first(PHOTOS_LIMIT).each_with_index do |photo, i|
      threads << Thread.new { load_photo(photo, i) }
    end
    threads.each(&:join)
  end

  def load_photo(link, file_name)
    Net::HTTP.start("static.flickr.com") { |http|
      resp = http.get(link)
      print "flickr_api/tmp/#{file_name}.jpg"
      open("#{@prefix}tmp/#{file_name}.jpg", "wb") { |file|
        file.write(resp.body)
      }
      puts ' +'
    }
  rescue StandardError => error
    puts ' -'
    puts '================================='
    puts error
    puts '================================='
  end

  def collect_user_photo_urls(words)
    print 'Search'
    return if words.empty?
    photos = []
    threads = []
    words.each do |word|
      threads << Thread.new do
        photos << top_photo_url_by_word(word)
      end
    end
    threads.each(&:join)
    photos.compact
  end

  def collect_dictionary_photo_urls(photos)
    i = 0 # infinity safe flag
    while (cnt = PHOTOS_LIMIT - photos.size) > 0
      threads = []
      i += 1
      FlickrApi::DictionaryReader.readlines(cnt) do |word|
        threads << Thread.new { photos << top_photo_url_by_word(word) }
      end
      threads.each(&:join)
      photos.compact!
      if i > 100
        @error = 'Incorrect dictionary. WARNING: infinite loop'
        return
      end
    end
    photos
  end

  def top_photo_url_by_word(word)
    word = word.gsub(/\W/, '')
    url = "#{API_URL}/?api_key=#{API_KEY}&text=#{word}"
    url << '&method=flickr.photos.search&per_page=1&page=1&format=json&nojsoncallback=1'
    uri = URI(url)
    resp = Net::HTTP.get(uri)
    img = JSON.parse(resp)['photos']['photo'].first
    return if img.empty? || img['id'].empty?
    print '.'
    "/#{img['server']}/#{img['id']}_#{img['secret']}_q.jpg"
  rescue StandardError => error
    puts '---------------------------------------'
    puts url
    puts error
    puts '---------------------------------------'
    @error = "Fail while downloading image by #{word} word"
  end
end
