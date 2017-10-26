<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ tag import="com.baosight.iplat4j.core.ei.EiBlock" %>
<%@ tag import="com.baosight.iplat4j.core.ei.EiInfo" %>
<%@ tag import="com.baosight.iplat4j.core.ei.json.Json2EiInfo" %>
<%@ tag import="java.util.List" %>
<%@ tag import="java.util.Map" %>
<%@ tag import="java.util.ArrayList" %>
<%@ attribute name="ename" description="按钮英文名" %>
<%@ attribute name="cname" description="按钮中文名" %>
<%@ attribute name="shape" description="按钮是否圆角" %>
<%@ attribute name="type" description="按钮颜色"%>
<%@ attribute name="size" description="按钮大小"%>
<%@ attribute name="icon" description="按钮图标"%>
<%@ attribute name="disabled" description="按钮是否禁用"%>
<%@ attribute name="full" description="按钮是否整行显示"%>
<%@ attribute name="blockId"  required="false" description="模块Id" %>
<%@ attribute name="isNeedPrivillege" required="false" rtexprvalue="true"  type="java.lang.Boolean" description="是否要进行权限判断" %>
<jsp:useBean id="ei" scope="request" class="com.baosight.iplat4j.core.ei.EiInfo" />

<%//权限判断
    boolean hasPrivilege = false;
    if(isNeedPrivillege == null || !isNeedPrivillege) {
        hasPrivilege = true;
    } else{
        ei =(EiInfo) request.getAttribute("ei");
        if(ei!=null){
            String efFormButtonDesc =(String) ei.get("efFormButtonDesc");
            EiInfo info = Json2EiInfo.parse(efFormButtonDesc);
            Map<String,EiBlock> blocks = info.getBlocks();
            List<Map> rows = new ArrayList<Map>();
            if(blockId != null){
                EiBlock  eiBlock = blocks.get(blockId);
                rows.addAll(eiBlock.getRows());
            }else {
                for (String key : blocks.keySet()) {
                    EiBlock eiBlock = blocks.get(key);
                    rows.addAll(eiBlock.getRows());
                }
            }
            for (Map row : rows) {
                if(ename.equalsIgnoreCase((String)row.get("button_ename"))&&"1".equals(row.get("button_status"))){
                    hasPrivilege = true;
                    break;
                }
            }

        }
    }
    request.setAttribute("hasPrivilege",hasPrivilege);
%>

<c:if test="${hasPrivilege}">
    <i-button id="${ename}" type="${type}" size="${size}" 
    shape="${shape}"
    icon="${icon}"
    <c:if test="${disabled}">disabled</c:if>
    <c:if test="${full}">long</c:if>
    onclick="javascript:efbutton.onClickButton('${ename}', '${cname}');">
        ${cname}
    </i-button>
</c:if>