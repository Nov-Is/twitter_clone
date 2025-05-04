# frozen_string_literal: true

RSpec::Matchers.define :be_unauthenticated do
  match do |response|
    expect(response).to have_http_status(:found)
    expect(flash[:alert]).to include('ログインもしくはアカウント登録してください')
  end

  failure_message do |response|
    "Response status: #{response.status}\n" \
    "Flash alert: #{flash[:alert].inspect}"
  end
end
