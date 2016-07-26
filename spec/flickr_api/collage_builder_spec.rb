require 'spec_helper'

describe FlickrApi::CollageBuilder do
  context '#call' do
    it 'raises error when images are absent' do
      allow_any_instance_of(described_class).to receive(:file_location).and_return('11.jpg')
      expect{ described_class.new('1').call }.to raise_error(StandardError)
    end

    it 'builds collage' do
      expect(File.file?('spec/tmp/test.jpg')).to be_falsey
      allow(Dir).to receive(:pwd).and_return('spec')
      described_class.new('test').call
      expect(File.file?('spec/tmp/test.jpg')).to be_truthy
      File.delete('spec/tmp/test.jpg') if File.file?('spec/tmp/test.jpg')
    end

    it 'builds collage with default name' do
      expect(File.file?('spec/tmp/collage.jpg')).to be_falsey
      allow(Dir).to receive(:pwd).and_return('spec')
      described_class.new('').call
      expect(File.file?('spec/tmp/collage.jpg')).to be_truthy
      File.delete('spec/tmp/collage.jpg') if File.file?('spec/tmp/collage.jpg')
    end
  end
end
