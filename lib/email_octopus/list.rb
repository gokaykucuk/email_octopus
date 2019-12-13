# frozen_string_literal: true
require 'email_octopus/contact'

module EmailOctopus
  # Mailing list.
  class List < Model
    attribute :id
    attribute :name

    def contacts
      Contact.where list_id: id
    end

    def create_contact(params = {})
      Contact.create params.merge(list_id: id)
    end

    def self.find(list_id)
      api    = API.new EmailOctopus.config.api_key
      params = api.get("/lists/#{list_id}", {}).body
			new(params)
    end

    def base_path
      "/lists"
    end

  end
end
