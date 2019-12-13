# frozen_string_literal: true

module EmailOctopus
  class API
    # Response object that parses out JSON.
    class Response
      delegate :status, :headers, to: :@raw

      def initialize(response)
        @raw = response
        raise error_class, self if error?
      end

      def status
        @raw.status
      end

      def headers
        @raw.headers
      end

      def success?
        @raw.is_a? HTTParty::Response
      end

      def error?
        !success? || !body["error"].nil?
      end

      def body
        JSON.parse @raw.body
      end

      def error_class
        return unless error?
        case body['error']['code']
        when 'MEMBER_EXISTS_WITH_EMAIL_ADDRESS'
          EmailOctopus::API::Error::MemberExists
        when 'INVALID_PARAMETERS'
          EmailOctopus::API::Error::InvalidParameters
        when 'API_KEY_INVALID'
          EmailOctopus::API::Error::ApiKeyInvalid
        when 'UNAUTHORISED'
          EmailOctopus::API::Error::Unauthorized
        when 'NOT_FOUND'
          EmailOctopus::API::Error::NotFound
        else
          EmailOctopus::API::Error
        end
      end
    end
  end
end
