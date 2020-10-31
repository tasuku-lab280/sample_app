import React, { useState, useCallback } from "react";

const Comment = (props) => {
  const item_id = props.item_id
  const [comment, setComment] = useState("");
  console.log(item_id, comment)

  // コメント入力
  const inputContent = useCallback(
    (event) => {
      setComment(event.target.value);
    },
    [setComment]
  );

  // テキストフォームリセット
  const resetInputField = () => {
    setComment("");
  };

  // コメント送信
  const sendComment = () => {
    resetInputField();
  };

  return (
    <form>
      <textarea onChange={inputContent} value={comment} className="form-control" rows="5"/>
      <button onClick={() => sendComment()} type="button" className="btn btn-secondary btn-block mt-2">
        コメントする
      </button>
    </form>
  );
}
export default Comment
