# frozen_string_literal: true

class SimpleStructuredApi < StructuredApi::Endpoint
  verb :post
  url 'https://google.com/'
  body 'just keep swimming'
  params q: 'fish'
end

class SimpleExtendedApi < SimpleStructuredApi
  verb :get
  path '/about'
  clear_body # NOTE: Body doesn't make sense on a get - maybe some autoswitching here?
  params q: 'cats'
end

class CustomizedApi < SimpleStructuredApi
  verb :get
  stringish_attr :id
  path :about

  def override_path
    "#{get_attr(:path)}/#{get_attr(:id)}"
  end
end

describe SimpleStructuredApi do
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
      subject { SimpleStructuredApi.new.run! }

      it 'passes the request to Typhoeus' do
        expect(subject).to eq 'dummy response'
        expect(WebMock).to have_requested(verb, uri).with(body: 'just keep swimming')
      end
    end

    context 'overriding the defaults manually' do
      let(:uri) { 'https://google.com?q=pizza' }
      let(:verb) { :get }
      subject { SimpleStructuredApi.new.verb(:get).params(q: :pizza).clear_body.run! }

      it 'passes the request to Typhoeus' do
        expect(subject).to eq 'dummy response'
        expect(WebMock).to have_requested(verb, uri).with { |req| req.body == '' }
      end
    end

    context 'overriding the defaults structurally' do
      let(:uri) { 'https://google.com/about?q=cats' }
      let(:verb) { :get }
      subject { SimpleExtendedApi.new.run! }

      it 'passes the request to Typhoeus' do
        expect(subject).to eq 'dummy response'
        expect(WebMock).to have_requested(verb, uri).with { |req| req.body == '' }
      end
    end

    context 'custom params' do
      let(:uri) { 'https://google.com/about/images?q=fish' }
      let(:verb) { :get }
      subject { CustomizedApi.new.id(:images).run! }

      it 'passes the request to Typhoeus' do
        expect(subject).to eq 'dummy response'
        expect(WebMock).to have_requested(verb, uri).with(body: 'just keep swimming')
      end
    end
  end
end
