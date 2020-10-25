module Notice::GenerateUrl
  # メソッド
  def generate_path(method_name, *args)
    send("#{method_name}_path", *args)
  end


  # メソッド (private)
  private

  def routes
    Rails.application.routes.url_helpers
  end

  ## チャットメッセージ
  def create_comment_path(chat_message)
    routes.chat_path(chat_message.chat_id)
  end
end
