require 'web_helper'

RSpec.describe '/hosts' do
  context 'POST /' do
    context 'with valid input' do
      let(:input) do
        {
          fqdn: 'foo.bor.usg.edu',
        }
      end

      it 'succeeds' do
        post_json '/hosts', input
        expect(last_response.status).to eq(200)
        host = parsed_body
        expect(host['id']).not_to be_nil
        expect(host['fqdn']).to eq('foo.bor.usg.edu')
      end
    end

    context 'with invalid input' do
      let(:input) do
        {
        }
      end

      it 'returns an error' do
        post_json '/hosts', input
        expect(last_response.status).to eq(422)
        host = parsed_body
        expect(host['errors']['fqdn']).to include('is missing')
      end
    end
  end
end
