import React, { useState, useEffect } from "react";
import axios from 'axios';
import ArticleItem from "./ArticleItem";

const ArticleIndex = () => {
  const [articles, setArticles] = useState([]);

  useEffect(() => {
    fetchArticles();
  }, []);

  // 記事一覧取得
  const fetchArticles = async (keywords) => {
    const URL = `http://localhost:3000/api/articles`
    const res = await axios.get(URL, {
      params: {
        keywords: keywords
      }
    });
    console.log(res.data.data);
    setArticles(res.data.data);
  };

  return (
    <div>
      <form className="form-group">
        <input type="text" name="keywords" onChange={(e) => fetchArticles(e.target.value)} placeholder="記事を検索する" className="form-control mt-5" />
      </form>
      <div className="row p-md-5">
        {articles.length > 0 &&
          articles.map((article, i) => (
            <ArticleItem
              key={i}
              link={article.link}
            />
          ))}
      </div>
    </div>
  );
}
export default ArticleIndex
