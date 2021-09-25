# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :projects do
      primary_key :id, Integer

      column :name, String, unique: true, null: false

      column :created_at, DateTime
      column :updated_at, DateTime
    end

    create_table :hosts do
      primary_key :id, Integer

      column :name, String, unique: true, null: false

      foreign_key :project_id, :projects

      column :created_at, DateTime
      column :updated_at, DateTime
    end

    create_table :services do
      primary_key :id, Integer

      column :name, String, unique: true, null: false

      foreign_key :project_id, :projects

      column :created_at, DateTime
      column :updated_at, DateTime
    end
  end
end
