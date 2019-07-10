# frozen_string_literal: true

class ClientforalertController < ApplicationController
  def create
    param = clientforalert_params
    user = Clientforalert.where(email: param[:email]).first_or_initialize
    user.key = param[:key]
    user.location_id = param[:location_id]
    user.save
  end

  private

  def clientforalert_params
    params.require(:clientforalert).permit(:email, :key, :location_id)
  end
end
