# frozen_string_literal: true

# name: samsung-dkms-01
# about: This plugin encrypt all the emails present in discouse DB and discourse logs.
# meta_topic_id: 001
# version: 0.0.1
# authors: Pankaj
# url: https://github.com/Nilay1004/samsung-dkms/blob/main/README.md
# required_version: 2.7.0

enabled_site_setting :samsung_dkms_plugin_enabled

unless defined?(::MyPluginModule)
  module ::MyPluginModule
    PLUGIN_NAME = "samsung-dkms"
  end
end

# Loads the extensions defined in the lib/extensions directory.
require_relative "lib/pii_encryption"

after_initialize do

  module ::SamsungDkms
    PLUGIN_NAME ||= "samsung-dkms-01"

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace SamsungDkms
    end
  end


  require_relative "lib/samsung_dkms/user_patch"
  require_relative "lib/samsung_dkms/emaillog_patch"
  require_relative "lib/samsung_dkms/skippedemaillog_patch"
  require_relative "lib/samsung_dkms/emailtoken_patch"
  require_relative "lib/samsung_dkms/invite_patch"
  require_relative "lib/samsung_dkms/sessioncontroller_patch"
  require_relative "lib/samsung_dkms/emailvalidator_patch"
  require_relative "lib/samsung_dkms/useremail_patch"

  reloadable_patch do |plugin|
    User.prepend(SamsungDkms::UserPatch)
    EmailLog.prepend(SamsungDkms::EmailLogPatch)
    SkippedEmailLog.prepend(SamsungDkms::SkippedEmailLogPatch)
    EmailToken.prepend(SamsungDkms::EmailTokenPatch)
    EmailValidator.prepend(SamsungDkms::EmailValidatorPatch)
    SessionController.prepend(SamsungDkms::SessionControllerPatch)
    UserEmail.prepend(SamsungDkms::UserEmailPatch)
    Invite.prepend(SamsungDkms::InvitePatch)
  end
end



  