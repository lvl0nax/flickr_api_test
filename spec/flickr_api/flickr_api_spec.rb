require 'spec_helper'

describe FlickrApi do
  it '.call send message to PhotoFetcher' do
    expect_any_instance_of(FlickrApi::CollageBuilder).to receive(:call)
    expect(FlickrApi::PhotoFetcher).to receive(:call).and_return({})
    described_class.fetch_photos('test', ['test'])
  end

  it '.call did not send message to collage builder when PhotoFetcher has error' do
    expect_any_instance_of(FlickrApi::CollageBuilder).to_not receive(:call)
    allow(FlickrApi::PhotoFetcher).to receive(:call).and_return({error: 'error'})
    described_class.fetch_photos('test', ['test'])
  end
end
