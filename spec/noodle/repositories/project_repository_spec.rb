require 'spec_helper'

RSpec.describe Noodle::Repositories::ProjectRepository do
  context '#create' do
    it 'creates a project' do
      project = subject.create(name: 'foo')

      expect(project.value!).to be_a(Noodle::Project)
      expect(project.value!.id).not_to be_nil
      expect(project.value!.name).to eq('foo')
    end
  end

  context '#find' do
    it 'finds a project' do
      subject.create(name: 'foo')

      project = subject.find(name: 'foo').one

      expect(project).to be_a(Noodle::Project)
      expect(project.id).not_to be_nil
      expect(project.name).to eq('foo')
    end
  end
end
