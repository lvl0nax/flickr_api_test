class FlickrApi::DictionaryReader
  DICTIONARY_PATH = '/usr/share/dict/words'.freeze


  def self.readlines(cnt = 1)
    unless File.file?(DICTIONARY_PATH)
      raise "Dictionary file does not found! (#{DICTIONARY_PATH})"
    end

    i = 0
    File.foreach(DICTIONARY_PATH) do |line|
      i += 1
      yield(line)
      break if i >= cnt
    end
  end

end
