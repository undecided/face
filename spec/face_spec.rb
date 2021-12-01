# frozen_string_literal: true

RSpec.describe Face do
  it 'has a version number' do
    expect(Face::VERSION).not_to be nil
  end

  context 'making api clients' do
    let(:expected_typhoeus_params) do
      [
        'https://google.com',
        { method: :get,
          body: nil,
          params: {},
          headers: {} }
      ]
    end

    let(:dummy_typhoeus) { instance_double(Typhoeus::Request, run: double(response_body: 'dummy response')) }

    before do
      expect(Typhoeus::Request).to receive(:new).with(*expected_typhoeus_params).and_return dummy_typhoeus
    end

    context 'direct mode' do
      subject { Face::Endpoint.new.url('https://google.com').verb(:get).run! }
      it 'passes the request to Typhoeus' do
        expect(subject).to eq 'dummy response'
      end
    end
  end
end
