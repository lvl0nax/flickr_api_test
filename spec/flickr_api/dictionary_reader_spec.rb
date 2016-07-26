require 'spec_helper'

describe FlickrApi::DictionaryReader do
  context '.readlines' do
    it 'raises error when dictionary file is absent' do
      allow(File).to receive(:file?).and_return(false)
      expect{ described_class.readlines(1) }
        .to raise_error("Dictionary file does not found! (#{described_class::DICTIONARY_PATH})")
    end

    it 'returns words from dictionary file' do
      stub_const("FlickrApi::DictionaryReader::DICTIONARY_PATH", 'spec/tmp/words')
      words = []
      described_class.readlines(5) do |word|
        words << word
      end
      expect(words).to match_array(%W(one\n two\n three\n four\n five\n))
    end

    it 'returns all words when request count > dictionary size' do
      stub_const("FlickrApi::DictionaryReader::DICTIONARY_PATH", 'spec/tmp/words')
      words = []
      described_class.readlines(500) do |word|
        words << word
      end
      expect(words).to match_array(%W(one\n two\n three\n four\n five\n six\n seven\n eight\n nine\n ten\n))
    end
  end
end
