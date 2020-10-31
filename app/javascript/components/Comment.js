import React, { useState, useCallback } from "react";
import CommentList from "./CommentList";

const Comment = (props) => {
  const item_id = props.item_id
  const [body, setBody] = useState("");
  console.log(item_id, body)

  // コメント入力
  const inputBody = useCallback(
    (event) => {
      setBody(event.target.value);
    },
    [setBody]
  );

  // テキストフォームリセット
  const resetInputField = () => {
    setBody("");
  };

  // コメント送信
  const sendComment = () => {
    resetInputField();
  };

  return (
    <div>
      <div>
        <CommentList item_id={item_id}/>
      </div>
      <p className="bg-warning rounded p-2">
        相手のことを考え丁寧なコメントを心がけましょう。不快な言葉遣いなどは利用制限や退会処分となることがあります。
      </p>
      <form>
        <textarea onChange={inputBody} value={body} className="form-control" rows="5"/>
        <button onClick={() => sendComment()} type="button" className="btn btn-secondary btn-block mt-2">
          コメントする
        </button>
      </form>
    </div>
  );
}
export default Comment
