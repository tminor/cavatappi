require 'spec_helper'

RSpec.describe Noodle::Repositories::HostRepository do
  let(:project_repo) { Noodle::Repositories::ProjectRepository.new }

  context '#create' do
    it 'creates a host' do
      project_repo.create(name: 'foo')
      host = subject.create(
        fqdn: 'foo.example.com',
        project: { name: 'foo' }
      ).value!

      expect(host).to be_a(Noodle::Host)
      expect(host.id).not_to be_nil
      expect(host.fqdn).to eq('foo.example.com')
    end
  end

  context '#combined_find' do
    it 'finds a host' do
      project_repo.create(name: 'foo')
      subject.create(
        fqdn: 'foo.example.com',
        project: { name: 'foo' }
      )

      host = subject.combined_find(fqdn: 'foo.example.com').one

      expect(host).to be_a(Noodle::Host)
      expect(host).not_to be_nil
      expect(host.fqdn).to eq('foo.example.com')
      expect(host.project).to be_a(Noodle::Project)
    end
  end
end
