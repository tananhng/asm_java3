<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../layout/header.jsp" %>

<main class="container">
<h2>Danh sách tin theo loại: <em>Công nghệ</em></h2>
<div class="cards">
  <article class="card">
    <a href="news-detail.jsp?id=C001"><img src="${pageContext.request.contextPath}/assets/img/tech1.jpg" alt=""></a>
    <h3><a href="news-detail.jsp?id=C001">Tiêu đề Tin 1</a></h3>
    <p>Trích dẫn ngắn gọn nội dung...</p>
  </article>
  <!-- lặp thêm vài card tĩnh -->
</div>
</main>

<%@ include file="../layout/footer.jsp" %>
