require 'spec_helper'

RSpec.describe Noodle::Repositories::ServiceRepository do
  let(:project_repo) { Noodle::Repositories::ProjectRepository.new }

  context '#create' do
    it 'creates a service' do
      project_repo.create(name: 'foo')
      service = subject.create(
        name: 'bar',
        project: { name: 'foo' }
      ).value!

      expect(service).to be_a(Noodle::Service)
      expect(service.id).not_to be_nil
      expect(service.name).to eq('bar')
    end
  end

  context '#combined_find' do
    it 'finds a service' do
      project_repo.create(name: 'foo')
      subject.create(
        name: 'bar',
        project: { name: 'foo' }
      )

      service = subject.combined_find(name: 'bar').one

      expect(service).to be_a(Noodle::Service)
      expect(service).not_to be_nil
      expect(service.name).to eq('bar')
      expect(service.project).to be_a(Noodle::Project)
    end
  end
end
