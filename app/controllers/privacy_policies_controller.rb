# frozen_string_literal: true

class PrivacyPoliciesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:privacy_policy]

  def privacy_policy; end

  def acknowledge_privacy
    current_user.privacy_acknowledged = true
    current_user.save!

    redirect_to root_path
  rescue StandardError
    redirect_to root_path
  end
end
