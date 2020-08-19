module Friends
  module ProfileEmoji
    class FalsyLoaded
      def loaded?
        false
      end
    end

    class Emoji < ActiveModelSerializers::Model
      SHORTCODE_RE_FRAGMENT = /@(#{Account::USERNAME_RE})(?:@([a-z0-9\.\-]+[a-z0-9]+))?/i

      SCAN_RE = /(?<=[^[:alnum:]:]|\n|^)
        (:#{SHORTCODE_RE_FRAGMENT}:)
        (?=[^[:alnum:]:]|$)/ix

      attributes :account

      Image = Struct.new(:source) do
        def url(type = :original)
          type = :original unless source.content_type == 'image/gif'
          source.url(type)
        end
      end

      def serializer_class
        REST::CustomEmojiSerializer
      end

      def shortcode
        "@#{account.acct}"
      end

      def image
        @image ||= Image.new(account.avatar)
      end

      def visible_in_picker
        false
      end

      # FIXME: NoMethodError object.association handling
      #
      # ref: app/serializers/rest/custom_emoji_serializer.rb:23:in `category_loaded?'
      def association(*_args)
        FalsyLoaded.new
      end

      class << self
        def from_text(text, domain)
          return [] if text.blank?

          shortcodes = text.scan(SCAN_RE).uniq

          return [] if shortcodes.empty?

          shortcodes.map { |_, username, _, server|
            server ||= domain
            server = nil if server == Rails.configuration.x.local_domain
            EntityCache.instance.avatar(username, server)
          }.compact.map { |account| new(account: account) }
        end
      end
    end
  end
end
