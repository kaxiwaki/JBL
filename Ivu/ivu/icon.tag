<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ tag import="com.baosight.iplat4j.core.ei.EiBlock" %>
<%@ tag import="com.baosight.iplat4j.core.ei.EiInfo" %>
<%@ tag import="com.baosight.iplat4j.core.ei.json.Json2EiInfo" %>
<%@ tag import="java.util.List" %>
<%@ tag import="java.util.Map" %>
<%@ tag import="java.util.ArrayList" %>
<%@ attribute name="type" description="图标代号"%>
<%@ attribute name="size" description="图标大小"%>

<icon type="${type}" size="${size}">