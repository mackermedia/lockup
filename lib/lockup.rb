require "lockup/engine"

module Lockup
  extend ActiveSupport::Concern

  included do
    before_filter :check_for_lockup, :except => ["unlock"]
  end

  private

  def check_for_lockup
    if ENV["LOCKUP_CODEWORD"].present?
      if cookies[:lockup].present?
        if cookies[:lockup] == ENV["LOCKUP_CODEWORD"].to_s.downcase
          return
        else
          redirect_to lockup.unlock_path(:return_to => request.fullpath.split('?lockup_codeword')[0], :lockup_codeword => params[:lockup_codeword])
        end
      else
        redirect_to lockup.unlock_path(:return_to => request.fullpath.split('?lockup_codeword')[0], :lockup_codeword => params[:lockup_codeword])
      end
    end
  end

end
