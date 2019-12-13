# frozen_string_literal: true
module EmailOctopus
  class API
    class Error < StandardError
      # Thrown when the member already exists.
      class MemberExists < Error
      end
    end
  end
end

