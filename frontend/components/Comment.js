import React, { useState, useEffect, useCallback } from "react";
import axios from 'axios';
import CommentItem from "./CommentItem";

const Comment = (props) => {
  const user_id = props.user_id
  const item_id = props.item_id
  const [body, setBody] = useState("");
  console.log(`user_id:${user_id}, item_id:${item_id}, body:${body}`)
  const [comments, setComments] = useState([]);
  console.log(comments);
  
  useEffect(() => {
    fetchComments();
  }, []);

  // コメント一覧取得
  const fetchComments = async() => {
    const URL = `http://localhost:3000/api/items/${props.item_id}/comments`
    const res = await axios.get(URL);
    setComments(res.data);
  };

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
  const sendComment = async() => {
    const URL = `http://localhost:3000/api/items/${props.item_id}/comments`
    await axios({
      method: "POST",
      url: URL,
      data: { user_id, item_id, body },
    })
    .then((res) => {
      console.log(res);
      fetchComments();
    })
    .catch((error) => {
      console.error(error);
    });
    resetInputField();
  };

  return (
    <div>
      <div>
        {comments.length > 0 &&
          comments.map((comment) => (
            <CommentItem
              key={comment.id}
              id={comment.id}
              body={comment.body}
              created_at={comment.created_at}
              user_id={comment.user_id}
              user_name={comment.user_name}
            />
          ))}
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
