# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def favorite_notification(user, post)
    @user = user
    @post = post
    mail(to: @post.user.email, subject: 'いいねがありました。')
  end

  def repost_notification(user, post)
    @user = user
    @post = post
    mail(to: @post.user.email, subject: 'リポストがありました。')
  end

  def comment_notification(user, post, comment)
    @user = user
    @post = post
    @comment = comment
    mail(to: @post.user.email, subject: 'コメントがありました。')
  end

  def follow_notification(following, user)
    @following = following
    @user = user
    mail(to: @user.email, subject: 'フォローされました。')
  end
end
