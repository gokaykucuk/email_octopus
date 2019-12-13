# frozen_string_literal: true

module EmailOctopus
  # Contact of a list
  class Contact < Model
    attribute :id
    attribute :list_id
    attribute :first_name
    attribute :last_name
    attribute :email_address
    attribute :subscribed
    attribute :created_at

    def self.where(list_id: '')
      api = API.new EmailOctopus.config.api_key
      api.get("/lists/#{list_id}/contacts", {}).body['data'].map do |params|
        new(params)
      end
    end

    def self.find(id: '', list_id: '')
      api = API.new EmailOctopus.config.api_key
			params = api.get("/lists/#{list_id}/contacts/#{id}", {}).body
			new(params)
    end

    def self.create(params = {})
      api  = API.new EmailOctopus.config.api_key
			resp = api.post("/lists/#{params[:list_id]}/contacts", params).body
			new(resp)
    end

    def as_json
      attributes.reject do |(key, _val)|
        /#{key.to_s}/ =~ 'list_id'
      end.to_h
    end

    def base_path
      "/lists/#{attributes[:list_id]}/contacts"
    end

  end
end
