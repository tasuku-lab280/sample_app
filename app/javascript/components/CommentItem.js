import React from "react";

const CommentItem = (props) => {
  return (
    <div className="mb-5">
      <div className="d-flex comment-area-container">
        <div>
          <div className="border mr-4" style={{width: 50, height: 50, borderRadius: 50}}>
          </div>
          <span className="badge badge-secondary mt-2">出品者</span>
        </div>
        <div>
          <span className="font-weight-bold">{props.user_name}</span>
          <div className="comment-area mt-2">
            <div>
              <p>{props.body}</p>
            </div>
            <div className="d-flex justify-content-between mt-4">
              {props.created_at}前
              <a href="#">削除</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
export default CommentItem
