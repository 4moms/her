require "her/model/base"
require "her/model/http"
require "her/model/attributes"
require "her/model/orm"
require "her/model/parse"
require "her/model/associations"
require "her/model/introspection"
require "her/model/paths"
require "her/model/nested_attributes"
require "active_model"

module Her
  # This module is the main element of Her. After creating a Her::API object,
  # include this module in your models to get a few magic methods defined in them.
  #
  # @example
  #   class User
  #     include Her::Model
  #   end
  #
  #   @user = User.new(:name => "Rémi")
  #   @user.save
  module Model
    extend ActiveSupport::Concern

    # Her modules
    include Her::Model::Base
    include Her::Model::Attributes
    include Her::Model::ORM
    include Her::Model::HTTP
    include Her::Model::Parse
    include Her::Model::Introspection
    include Her::Model::Paths
    include Her::Model::Associations
    include Her::Model::NestedAttributes

    # Supported ActiveModel modules
    include ActiveModel::Validations
    include ActiveModel::Conversion
    include ActiveModel::Dirty
    include ActiveModel::Naming
    include ActiveModel::Translation

    # Class methods
    included do
      # Define the root element name, used when `parse_root_in_json` is set to `true`
      root_element self.name.split("::").last.underscore.to_sym

      # Define resource and collection paths
      collection_path "#{root_element.to_s.pluralize}"
      resource_path "#{root_element.to_s.pluralize}/:id"

      # Assign the default API
      uses_api Her::API.default_api

      # Configure ActiveModel callbacks
      extend ActiveModel::Callbacks
      define_model_callbacks :create, :update, :save, :find, :destroy
    end
  end
end
