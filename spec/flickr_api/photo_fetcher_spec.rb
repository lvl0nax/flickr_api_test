require 'spec_helper'

describe FlickrApi::PhotoFetcher do
  context 'class methods' do
    it '.call initializes instance and invokes #fetch method' do
      expect_any_instance_of(described_class).to receive(:fetch)
      described_class.call(['test'])
    end
  end

  context 'instance methods' do
    # allow(Net::HTTP).to receive(:get).and_return(search_flickr_json)

    it 'invokes #collect_user_photo_urls method' do
      allow_any_instance_of(described_class).to receive(:load_photo) do |_link, filename|
        "#{filename}.jpg"
      end

      expect_any_instance_of(described_class).to receive(:collect_user_photo_urls)
      described_class.call(['test'])
    end

    it '#collect_user_photo_urls returns 1 image url' do
      allow_any_instance_of(described_class).to receive(:download).and_return(nil)
      allow(Net::HTTP).to receive(:get).and_return(search_flickr_json)

      expect_any_instance_of(described_class)
        .to receive(:collect_dictionary_photo_urls).with(['/8655/28546197735_772f344141_q.jpg'])
      described_class.call(['test'])
    end

    it '#collect_dictionary_photo_urls returns 10 image urls fetch by dictionary words' do
      allow(Net::HTTP).to receive(:get).and_return(search_flickr_json)

      expect_any_instance_of(described_class)
        .to receive(:download).with(%w(/8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg /8655/28546197735_772f344141_q.jpg))
      described_class.call(['test'])
    end

    it '#fetch invokes #load_photo method' do
      expect_any_instance_of(described_class).to receive(:load_photo).exactly(10).times
      described_class.call(['test'])
    end
  end
end

def search_flickr_json
  '{
    "photos": {
      "page": 1,
      "pages": 368603,
      "perpage": 1,
      "total": "368603",
      "photo": [
        {
          "id": "28546197735",
          "owner": "96711656@N07",
          "secret": "772f344141",
          "server": "8655",
          "farm": 9,
          "title": "CBS201607252130.jpg",
          "ispublic": 1,
          "isfriend": 0,
          "isfamily": 0
        }
      ]
    },
    "stat": "ok"
  }'
end
