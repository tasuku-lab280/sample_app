module Notice::GenerateMessage
  # ===== ユーザが自由に入力できる値は必ずサニタイズすること =====

  # メソッド
  def generate_message(method_name, *args)
    send("#{method_name}_message", *args)
  end


  # メソッド (private)
  private

  def notice_sanitize(message)
    @full_sanitizer ||= Rails::Html::FullSanitizer.new
    @full_sanitizer.sanitize(message)
  end

  ## コメント
  def create_comment_message(comment)
    body = if comment.body.present?
             "『#{notice_sanitize(comment.body).truncate(Notice::MESSAGE_LIMIT)}』"
           else
            comment.image.present? ? '画像を送信しました。' : 'ファイルを送信しました。'
           end
    nickname = notice_sanitize(comment.author.nickname)
    "<span class='font-weight-bold'>#{nickname}</span>さん：" + body
  end
end
