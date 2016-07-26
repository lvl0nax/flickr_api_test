require 'mini_magick'

class FlickrApi::CollageBuilder
  def initialize(filename)
    @filename = filename.empty? ? 'collage' : filename
    @prefix = '../' if Dir.pwd.include?('bin') # handling case when flickr_getter running from bin folder
  end

  def call
    montage = MiniMagick::Tool::Montage.new
    (0..9).each { |num| montage << file_location("#{num}.jpg") }
    montage << '-mode'
    montage << 'Concatenate'
    montage << '-background'
    montage << 'none'
    montage << '-geometry'
    montage << '150x150+0+0'
    montage << '-tile'
    montage << '5x2'
    montage << file_location("#{@filename}.jpg")
    puts montage.call
    puts '================================================='
    puts "Collage location: flickr_api/tmp/#{@filename}.jpg"
  end

  private

  def file_location(name)
    Dir.pwd + "/#{@prefix}tmp/#{name}"
  end
end
