<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp" />

<c:url var="homeUrl"     value="/users"><c:param name="view" value="list"/></c:url>
<c:url var="dashUrl"     value="/admin"><c:param name="action" value="dashboard"/></c:url>
<c:url var="newsListUrl" value="/admin"><c:param name="action" value="list"/></c:url>
<c:url var="editNewsUrl" value="/admin"><c:param name="action" value="edit"/></c:url>
<c:url var="catsUrl"     value="/admin"><c:param name="action" value="categories"/></c:url>
<c:url var="subsUrl"     value="/admin"><c:param name="action" value="newsletters"/></c:url>

<div class="layout-admin">
  <jsp:include page="/WEB-INF/views/layout/sidebar.jsp" />

  <section class="page">
    <h2><fmt:message key="admin.dashboard.title"/></h2>

    <c:if test="${not empty message}">
      <div class="alert" style="margin:10px 0; padding:10px; border:1px solid #e5e7eb; background:#fef3c7">
        ${message}
      </div>
    </c:if>

    <!-- Cards thống kê -->
    <div class="cards" style="margin-top:12px">
      <article class="card"><div style="padding:16px">
        <div style="opacity:.7"><fmt:message key="admin.cards.totalNews"/></div>
        <div style="font-size:28px; font-weight:700">${countNews != null ? countNews : 0}</div>
      </div></article>

      <article class="card"><div style="padding:16px">
        <div style="opacity:.7"><fmt:message key="admin.cards.categories"/></div>
        <div style="font-size:28px; font-weight:700">${countCategories != null ? countCategories : 0}</div>
      </div></article>

      <article class="card"><div style="padding:16px">
        <div style="opacity:.7"><fmt:message key="admin.cards.users"/></div>
        <div style="font-size:28px; font-weight:700">${countUsers != null ? countUsers : 0}</div>
      </div></article>

      <article class="card"><div style="padding:16px">
        <div style="opacity:.7"><fmt:message key="admin.cards.subscribers"/></div>
        <div style="font-size:28px; font-weight:700">${countSubs != null ? countSubs : 0}</div>
      </div></article>
    </div>

    <!-- Hành động nhanh -->
    <div class="cards" style="margin-top:16px">
      <article class="card">
        <div style="padding:16px">
          <h3 style="margin:0 0 8px"><fmt:message key="admin.quick.title"/></h3>
          <p style="margin:0 0 10px; opacity:.8"><fmt:message key="admin.quick.subtitle"/></p>

          <p style="margin:0 0 8px"><a class="btn" href="${editNewsUrl}">+ <fmt:message key="admin.quick.addNews"/></a></p>
          <p style="margin:0 0 8px"><a class="btn" href="${newsListUrl}"><fmt:message key="admin.quick.manageNews"/></a></p>
          <p style="margin:0 0 8px"><a class="btn" href="${catsUrl}"><fmt:message key="admin.quick.manageCategories"/></a></p>
          <p style="margin:0"><a class="btn" href="${subsUrl}"><fmt:message key="admin.quick.manageNewsletters"/></a></p>
        </div>
      </article>
    </div>

    <!-- Bài viết mới -->
    <section style="margin-top:22px">
      <h3><fmt:message key="admin.recent.title"/></h3>
      <table class="table">
        <thead>
          <tr>
            <th><fmt:message key="admin.table.id"/></th>
            <th><fmt:message key="admin.table.title"/></th>
            <th><fmt:message key="admin.table.category"/></th>
            <th><fmt:message key="admin.table.home"/></th>
            <th><fmt:message key="admin.table.views"/></th>
            <th><fmt:message key="admin.table.date"/></th>
            <th><fmt:message key="admin.table.actions"/></th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty latestNews}">
              <tr><td colspan="7"><em><fmt:message key="common.empty"/></em></td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="n" items="${latestNews}">
                <tr>
                  <td>${n.id}</td>
                  <td style="max-width:420px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap">${n.title}</td>
                  <td>${empty n.categoryName ? n.categoryId : n.categoryName}</td>
                  <td><c:if test="${n.home}">✓</c:if></td>
                  <td>${n.viewCount != null ? n.viewCount : 0}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty n.postedDate}">
                        <fmt:formatDate value="${n.postedDate}" pattern="dd/MM/yyyy HH:mm"/>
                      </c:when>
                      <c:otherwise>—</c:otherwise>
                    </c:choose>
                  </td>
                  <td>
                    <a href="<c:url value='/admin'><c:param name='action' value='edit'/><c:param name='id' value='${n.id}'/></c:url>">
                      <fmt:message key="common.edit"/>
                    </a>
                    |
                    <a href="<c:url value='/users'><c:param name='view' value='detail'/><c:param name='id' value='${n.id}'/></c:url>" target="_blank">
                      <fmt:message key="common.view"/>
                    </a>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </section>
  </section>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp" />
