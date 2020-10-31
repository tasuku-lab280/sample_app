import React, { useState, useCallback } from "react";

const CommentItem = () => {
  return (
    <div className="mb-5">
      <div className="d-flex comment-area-container">
        <div>
          <div className="border mr-4" style={{width: 50, height: 50, borderRadius: 50}}>
          </div>
          <span className="badge badge-secondary mt-2">出品者</span>
        </div>
        <div>
          <span className="font-weight-bold">名前</span>
          <div className="comment-area mt-2">
            <div>
              <p>コメント本文</p>
            </div>
            <div className="d-flex justify-content-between mt-4">
              3日前
              <a href="#">削除</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
export default CommentItem
