# frozen_string_literal: true

class SimpleFace < Face::Endpoint
  verb :post
  url 'https://google.com'
  body 'just keep swimming'
  params q: 'fish'
end

describe SimpleFace do
  let(:uri) { 'https://google.com?q=fish' }
  let(:verb) { :post }

  let(:do_the_stubbing) do
    stub_request(:any, uri).to_return(body: 'dummy response')
  end

  context 'making api clients' do
    before do
      do_the_stubbing
    end

    context 'defaulting to the items given during setup' do
      subject { SimpleFace.new.run! }

      it 'passes the request to Typhoeus' do
        expect(subject).to eq 'dummy response'
        expect(WebMock).to have_requested(verb, uri).with(body: 'just keep swimming')
      end
    end

    context 'overriding the defaults' do
      let(:uri) { 'https://google.com?q=pizza' }
      let(:verb) { :get }
      subject { SimpleFace.new.verb(:get).params(q: :pizza).clear_body.run! }

      it 'passes the request to Typhoeus' do
        expect(subject).to eq 'dummy response'
        expect(WebMock).to have_requested(verb, uri).with { |req| req.body == '' }
      end
    end
  end
end
