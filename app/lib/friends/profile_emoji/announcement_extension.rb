module Friends
  module ProfileEmoji
    module AnnouncementExtension
      extend ActiveSupport::Concern

      def profile_emojis
        @profile_emojis ||= Friends::ProfileEmoji::Emoji.from_text(text, nil)
      end

      def all_emojis
        emojis + profile_emojis
      end
    end
  end
end
