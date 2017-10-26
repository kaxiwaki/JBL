<%@ tag pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ tag import="com.baosight.iplat4j.core.ei.EiConstant" %>
<%@ tag import="com.baosight.iplat4j.core.ei.EiInfo" %>
<%@ tag import="com.baosight.iplat4j.core.ei.json.EiInfo2Json2" %>
<%@ tag import="com.baosight.iplat4j.core.log.Logger" %>
<%@ tag import="com.baosight.iplat4j.core.log.LoggerFactory" %>
<%@ tag import="com.baosight.iplat4j.core.service.soa.XLocalManager" %>
<%@ tag import="java.util.UUID" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="EF" tagdir="/WEB-INF/tags/EF" %>
<%--
    autoDraw有四种状态
    autoDraw=="no": 要求EFGrid必须有EFColumn子标签。只渲染自定义列EFColum Tag中的列，忽略EiBlock；
    autoDraw=="override": 要求EFGrid必须有EFColumn子标签。只渲染自定义列EFColum Tag中的列，覆盖EiBlock；
    autoDraw=="yes:" 只渲染EiBlock中的列，忽略所有的EFColum Tag；
    autoDraw=="mixed": 渲染EiBlock中的列，根据EFColumn Tag的配置，灵活渲染：

        1. EFColumn Tag中的ename 如果存在于EiBlock中，则使用EFColumn的配置覆盖EiBlock中的列设置
        2. EFColumn Tag中的ename 如果不存在于EiBlock中，则将EFColumn追加到最后一列。
--%>
<%@ attribute name="autoBind" type="java.lang.Boolean" description="是否自动绑定eiblock的行数据" %>
<%@ attribute name="blockId" description="grid对应的数据块的Id" %>

<%@ attribute name="checkMode" description="控制checkbox的勾选模式，single只能单行勾选， row表示点击行就可以勾选，
默认值是multiple, cell表示可以勾选多行，而且必须通过点击列头的checkbox勾选" %>

<%@ attribute name="filterable" type="java.lang.Boolean"
              description="数据列所有的数据列都可以查询" %>

<%@ attribute name="sort"
              description="控制表格的排序,可选值为single, all, setted" %>

<%@ attribute name="sumType"
              description="表格小计总计设置，可选值为page，total，all，默认值为none" %>

<%@ attribute name="autoDraw"
              description="数据列渲染的方式，根据后台EiBlock和EFColumn子标签灵活渲染" %>

<%@ attribute name="needAuth" type="java.lang.Boolean"
              description="Grid上的新增保存删除按钮是否进行权限判断，默认是true" %>

<%@ attribute name="copyToAdd" type="java.lang.Boolean"
              description="新增行时，是否复制已经勾选的行, 默认复制勾选的行" %>

<%@ attribute name="height" description="设置grid的高度值" %>

<%@ attribute name="readonly" type="java.lang.Boolean"
              description="默认是false，为true时，不能编辑编辑所有数据，但是可以选中数据进行提交
              不能新增数据" %> <%-- 新增数据时可编辑 --%>

<%@ attribute name="rowNo" type="java.lang.Boolean"
              description="Grid是否存在序列号，默认是false，不存在序列号" %>

<%@ attribute name="autoFit" type="java.lang.Boolean"
              description="Grid中列宽度根据自身内容自动扩展" %>

<%@ attribute name="showCount" type="java.lang.Boolean"
              description="默认是true，false表示不展示总条数，总页数。
              为true时，展示总共条数，总页数，需要在后端把总条数返回" %>

<%@ attribute name="enable" type="java.lang.Boolean"
              description="默认为true，为false时，不能编辑所有数据，没有checkbox列，仅作展示用" %>

<%@ attribute name="serviceName" description="表格增删改查对应的后台服务名" %>

<%@ attribute name="queryMethod" description="查询数据对应的后台处理方法" %>
<%@ attribute name="insertMethod" description="新增数据对应的后台处理方法" %>
<%@ attribute name="updateMethod" description="更新数据对应的后台处理方法" %>
<%@ attribute name="deleteMethod" description="删除数据对应的后台处理方法" %>

<%@ attribute name="pagerPosition" description="grid翻页条位置，默认是bottom占一行，可选值为top，在grid的右上角" %>

<%@ attribute name="toolbarConfig" description="配置工具栏的新增按钮, 保存，删除按钮是否显示" %>
<%@ attribute name="personal" description="个性化的功能设置" %>
<%@ tag dynamic-attributes="attributes" description="动态设置的属性，类似以前的etc属性" %>

<jsp:useBean id="ei" scope="request" class="com.baosight.iplat4j.core.ei.EiInfo"/>

<%
    final Logger logger = LoggerFactory.getLogger(this.getClass());
    String tagId = blockId + "-" + UUID.randomUUID().toString();
    request.setAttribute("EFGrid_BlockId", tagId);
    if (autoBind == null) {
        autoBind = true;
    }

    if (sumType == null) {
        sumType = "none";
    }

    String personalInfo = "";
    if (personal != null) {
        try {
            EiInfo personalEiInfo = new EiInfo();
            String projectEname = (String) request.getAttribute("IPLAT_PROJECT_ENAME");
            String formEname = (String) request.getAttribute("IPLAT_FORM_ENAME");
            String userId = (String) request.getAttribute("IPLAT_USER_ID");

            personalEiInfo.set(EiConstant.serviceName, "EDFA60");
            personalEiInfo.set(EiConstant.methodName, "query");

            personalEiInfo.set(EiConstant.queryBlock + EiConstant.separator +
                    "0" + EiConstant.separator + "project_ename", projectEname);
            personalEiInfo.set(EiConstant.queryBlock + EiConstant.separator +
                    "0" + EiConstant.separator + "form_ename", formEname);
            personalEiInfo.set(EiConstant.queryBlock + EiConstant.separator +
                    "0" + EiConstant.separator + "grid_id", blockId);
            personalEiInfo.set(EiConstant.queryBlock + EiConstant.separator +
                    "0" + EiConstant.separator + "user_id", userId);
            personalEiInfo.set("personal_" + blockId + EiConstant.separator + "limit", 1000);

            EiInfo outInfo = XLocalManager.call(personalEiInfo);

            personalInfo = EiInfo2Json2.toJsonString(outInfo); // version2
        } catch (Exception e) {
            logger.error("无法获取表格[" + blockId + "]的自定义列信息", e);
        }
    }
%>

<div class="k-content" style="overflow: auto">
    <div id="ef_window_<%=blockId%>"></div>

    <div id="ef_personal_window_<%=blockId%>">
        <div id="ef_personal_grid_<%=blockId%>"></div>
    </div>
    <div id="ef_grid_<%=blockId%>" class="no-scrollbar"></div>
</div>

<script>
    $(function () {
        var eiInfo = __eiInfo; // initLoad中的EiInfo
        var config = {
            <c:forEach var="item" items="${attributes}" varStatus="loop">
            "${item.key}": <EF:EFJSON value="${item.value}"/><c:if test="${!loop.last}">, </c:if>
            </c:forEach>
        };
            sumType: "<%=sumType%>",
            columns: [],
            readonlyColumns: []
        };

        // 处理EFColumn子标签
        <jsp:doBody/>

        IPLATUI.EFGrid['${blockId}'] = $.extend({}, IPLATUI.EFGrid['${blockId}']);

        if (!$.isFunction(IPLATUI.EFGrid['${blockId}'].edit)) { // 只读列，如果没有写Grid的edit事件
            IPLATUI.EFGrid['${blockId}'].edit = function (e) {
                var that = this;
                IPLAT.EFGrid._readonlyAddEdit('<%=tagId%>', e, that);
            };
        }

        if (!eiInfo.getBlock("<%=blockId%>") && <%=autoBind%>) { // initLoad 找不到block信息，且autoBind设置为true
            var serviceName = "${serviceName}" || eiInfo.get("serviceName");
            var queryMethod = "${queryMethod}" || "query";

            var promise = EiCommunicator.send(serviceName, queryMethod, eiInfo);

            promise.then(function (response) { // 主动查询成功
                eiInfo = EiInfo.parseJSONObject(response);
                initGrid(eiInfo, false); // kendo autoBind设置为false
            }, function () {
                // query出错 初始化时必须有Meta信息， blockId需要引号，否则被理解为form中的result DivElement
                NotificationUtil("表格[" + "<%=blockId%>" + "]初始化失败，原因[缺失数据块]", "error");

            });
        } else { // initLoad存在block信息，或者 autoBind设置为false
            // autoBind为true 也要转为kendo autoBind false，不进行query查询
            initGrid(eiInfo, false);
        }

        function initGrid(ei, autoBind) {
            return window['<%=blockId%>Grid'] = IPLAT.Grid({
                tagId: "<%=tagId%>",
                blockId: "<%=blockId%>",
                gridId: "ef_grid_<%=blockId%>",
                autoBind: autoBind,

                <c:if test="${not empty autoDraw}">
                autoDraw: "${autoDraw}",
                </c:if>

                <c:if test="${not empty needAuth}">
                needAuth: ${needAuth},
                </c:if>

                <c:if test="${not empty copyToAdd}">
                copyToAdd: ${copyToAdd},
                </c:if>

                <c:if test="${not empty readonly}">
                readonly: ${readonly},
                </c:if>

                <c:if test="${not empty enable}">
                enable: ${enable},
                </c:if>

                <c:if test="${not empty rowNo}">
                rowNo: ${rowNo},
                </c:if>

                <c:if test="${not empty autoFit}">
                autoFit: ${autoFit},
                </c:if>

                <c:if test="${not empty showCount}">
                showCount: ${showCount},
                </c:if>

                <c:if test="${not empty checkMode}">
                checkMode: "${checkMode}",
                </c:if>

                <c:if test="${not empty personal}">
                personal: "${personal}",
                personalInfo: EiInfo.parseJSONString('<%= personalInfo%>'),
                </c:if>

                <c:if test="${filterable}">
                filterable: {
                    extra: false
                },
                </c:if>
                <%-- sort是kendoGrid options的保留属性 --%>
                <c:if test="${not empty sort}">
                iplatSort: "${sort}",
                </c:if>

                <c:if test="${not empty sumType}">
                sumType: "${sumType}",
                </c:if>

                <c:if test="${not empty pagerPosition}">
                pagerPosition: "${pagerPosition}",
                </c:if>

                url: "<%=request.getContextPath()%>/service",
                eiInfo: ei,

                <c:if test="${not empty height}">
                height: "<%=height%>",
                </c:if>
                dynamic: config, // EFGrid上的个性化配置

                toolbarConfig: <%=toolbarConfig%>,
                serviceName: '${serviceName}',
                queryMethod: '${queryMethod}',
                insertMethod: '${insertMethod}',
                updateMethod: '${updateMethod}',
                deleteMethod: '${deleteMethod}'
            });
        }
    });
</script>

