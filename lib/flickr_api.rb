require 'flickr_api/version'
require 'flickr_api/dictionary_reader'
require 'flickr_api/photo_fetcher'
require 'flickr_api/collage_builder'

module FlickrApi
  def self.fetch_photos(filename, *words)
    fetch_results = FlickrApi::PhotoFetcher.call(words)
    return fetch_results[:error] if fetch_results[:error]

    CollageBuilder.new(filename).call
  end
end
