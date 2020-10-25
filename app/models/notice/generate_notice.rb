module Notice::GenerateNotice
  extend ActiveSupport::Concern

  # モジュール
  included do
    extend GenerateMessage
    extend GenerateUrl
  end


  module ClassMethods
    # クラスメソッド
    def generate_by(method_name, *args)
      send("#{method_name}_notice", method_name, *args)
    end


    # クラスメソッド (private)
    private

    ## コメント
    def create_comment_notice(method_name, comment)
      sender_id = comment.user_id
      body = generate_message(method_name, comment)
      url = generate_path(method_name, comment)
      new(sender_id: sender_id, body: body, url: url)
    end
  end
end
