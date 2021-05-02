import React from "react";

const ArticleItem = (props) => {
  return (
    <div className="col-md-4 col-sm-6 mb-5">
      <div className="card">
        <svg className="bd-placeholder-img card-img-top" width="100%" height="100" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice" focusable="false" role="img" aria-label="Placeholder: Image cap"><title>Placeholder</title><rect fill="#868e96" width="100%" height="100%" /></svg>
        <div className="card-body" dangerouslySetInnerHTML={{ __html: props.link }}>
        </div>
      </div>
    </div>
  );
}
export default ArticleItem
