import React, { useState, useEffect } from "react";
import axios from 'axios';
import CommentItem from "./CommentItem";

const CommentList = (props) => {
  // const [comments, setComments] = useState([]);

  // useEffect(async () => {
  //   fetchComments()
  // }, []);

  // const fetchComments = async() => {
  //   const URL = `http://localhost:3000/items/${props.item_id}`
  //   const res = await axios(URL);
  //   setComments(res.data);
  // }

  return (
    <div>
      コメント
      <CommentItem />
    </div>
  );
}
export default CommentList
