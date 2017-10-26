<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- <%@ tag import="com.baosight.iplat4j.core.ei.EiBlock" %> -->
<!-- <%@ tag import="com.baosight.iplat4j.core.ei.EiInfo" %> -->
<!-- <%@ tag import="com.baosight.iplat4j.core.ei.json.Json2EiInfo" %> -->
<!-- <%@ tag import="java.util.List" %> -->
<!-- <%@ tag import="java.util.Map" %> -->
<!-- <%@ tag import="java.util.ArrayList" %> -->
<%@ attribute name="type" description="标签样式，dot/border"%>
<%@ attribute name="color" description="标签颜色，blue/green/red/yellow/default"%>
<%@ attribute name="text" description="标签显示的文本内容" %>
<%@ attribute name="closable" description="标签是否可以关闭" %>

<tag type="${type}" color="${color}" 
  <c:if test="${closable}">
    closable
  </c:if>
>${text}</tag>
