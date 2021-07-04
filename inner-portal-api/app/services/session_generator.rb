# frozen_string_literal: true

class SessionGenerator
  attr_reader :payload, :session, :user

  def initialize(user)
    @user    = user
    @payload = { user_id: user.id }
    @session = JWTSessions::Session.new(payload: payload, refresh_payload: payload)
  end

  def data_for_caching
    @data_for_caching ||= {
      user:      UserSerializer.render_as_hash(user, view: :data_for_caching),
      position:  PositionSerializer.render_as_hash(user.position),
      division:  DivisionSerializer.render_as_hash(user.division),
      dashboard: DashboardSerializer.render_as_hash(user.dashboard)
    }
  end

  def login
    @session.login
  end

  def login_with_cache
    login.merge(data_for_caching)
  end
end
