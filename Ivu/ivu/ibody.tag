<jsp:useBean id="ei" scope="request" class="com.baosight.iplat4j.core.ei.EiInfo"/>
<%@ tag language="java" pageEncoding="UTF-8"
        %>
<%@ tag import="org.owasp.esapi.ESAPI"
        %>
<%@ tag import="org.owasp.esapi.Encoder"
        %>
<%@ tag import="com.baosight.iplat4j.security.SecurityTokenFilter"
        %>
<%@ tag import="com.baosight.iplat4j.core.spring.SpringApplicationContext"
        %>
<%@ tag import="com.baosight.iplat4j.core.ei.EiConstant"
        %>
<%@ tag import="com.baosight.iplat4j.core.FrameworkInfo"
        %>
<%@ tag import="com.baosight.iplat4j.core.resource.I18nMessages"
        %>
<%@ tag import="com.baosight.iplat4j.ep.monitor.DiagnosticJob"
        %>
<%@ tag import="com.baosight.iplat4j.ep.monitor.DiagnosticJobType"
        %>
<%@ tag import="com.baosight.iplat4j.ep.monitor.Diagnostics"
        %>
<%@ taglib prefix="ivu" tagdir="/WEB-INF/tags/ivu"
        %>
<%@ taglib prefix="EF" uri="/WEB-INF/framework/tlds/EF-2.0.tld"
        %>
<%
    String actionUrl = request.getContextPath() + "/DispatchAction.do";

    String efFormEname = (String) request.getAttribute("efFormEname");
    String efFormCname = (String) request.getAttribute("efFormCname");

    if (efFormEname == null) {
        efFormEname = (String) request.getParameter("efFormEname");
    }

    String efSecurityToken = null;
    if (SpringApplicationContext.containsBean("securityTokenFilter")) {
        SecurityTokenFilter securityTokenFilter = (SecurityTokenFilter) SpringApplicationContext.getBean("securityTokenFilter");
        efSecurityToken = securityTokenFilter.getSecurityToken(request);
    }

    DiagnosticJob log = Diagnostics.start(DiagnosticJobType._0600_FORM_RENDER, efFormEname, request.getRequestURI());
    //pageContext.setAttribute("__log__", log, PageContext.REQUEST_SCOPE);

    String pageTitle = efFormEname + "/" + efFormCname;

    Encoder encoder = ESAPI.encoder();

    //获取当前sessionId保存到隐藏域中，用于session恢复
    String cookieStr = request.getSession(false).getId();
%><%
    String domain = FrameworkInfo.getProjectAppTopDomain();
    if (domain != null && domain.startsWith(".")) {
        domain = domain.substring(1);
%>
<script type="text/javascript">
    try {
        document.domain = '<%=domain%>';
    } catch (ex) {
        alert('domain not valid[<%=domain%>]');
    }
</script>
<%
    }
%>
<script type="text/javascript">
    <%String isDiagForm = efFormEname == null ? "false" : (efFormEname.startsWith("EP31") ? "true" : "false");%>
    function find_diagnose_window() {
        if (<%=isDiagForm%>) return null;
        var _wnd = window;
        try {
            while (isAvailable(_wnd) && !isAvailable(_wnd._DIAGNOSE_ID)) {
                try {
                    if (isAvailable(_wnd.opener) && _wnd != _wnd.opener) {
                        _wnd = _wnd.opener;
                        continue;
                    }
                    if (isAvailable(_wnd.parent) && _wnd != _wnd.parent) {
                        _wnd = _wnd.parent;
                        continue;
                    }
                    if (isAvailable(_wnd.top) && _wnd != _wnd.top) {
                        _wnd = _wnd.top;
                        continue;
                    }
                } catch (ex) {
                    _wnd = null;
                    break;
                }
                _wnd = null;
                break;
            }
        } catch (_ex) {
            return null;
        }
        return _wnd;
    }
    /*
     var d_wnd = find_diagnose_window();
     if (d_wnd != null) {
     d_wnd.diagnose(3, null, window);
     }
     */

    //注销或刷新父页面时注销子页面
    window.onunload = function () {
        for (var propName in winMap) {
            try {
                winMap[propName].close();
            } catch (e) {
            }
        }

    }
</script>
<body class="ace iplat no-skin">
    <div id="app">
<script type="text/javascript">
    if (typeof(iplat) == "undefined") iplat = {};
</script>
<!-- #section:basics/navbar.layout -->
<div id="navbar" class="navbar navbar-default" style="display:none"></div>
<form id="<%= efFormEname %>" method="POST" action="<%=actionUrl%>">
    <!-- 页面加载层 -->
    <div id='efFormLoadingOverLay' class='ef-overlay ef-widget-overlay' style='z-index:9991;'>
	    <div id='efFormLoadingDiv' class='ef-overlay ef-form-loading-div ui-state-default' style='z-index:9992;'>
	        <img style="margin:auto;" src="./EF/Images/ef_loading.gif"><br/>
	        <span style="margin:auto;position: absolute;top: 5px;right: 5px;" class="ui-icon ui-icon-circle-close"></span>
	    </div>
	</div>
    <script type="text/javascript">
        $("#efFormLoadingDiv").find("span.ui-icon-circle-close").click(function () {
            efform.hideOverlay();
        });
    </script>
    <div id='ef_form_head' class='page-header'>
        <h3 class="pull-left"><%=encoder.encodeForHTML(efFormCname)%>
            <small>
                > <%=encoder.encodeForHTMLAttribute(efFormEname)%>
            </small>
        </h3>

        <!-- 配置按钮图标 -->
        <div class="widget-toolbar" role="navigation">
            <div class="widget-menu">
                <a data-toggle="dropdown" href="#" data-action="settings"><i class="ace-icon fa fa-gear"></i></a>
                <ul class="dropdown-menu dropdown-menu-right dropdown-light-blue dropdown-caret dropdown-closer">
                    <li><a id='_efFormMenu_close' href="javascript:window.close();"><i class="ace-icon fa fa-times"></i>&nbsp;关闭窗口</a>
                    </li>

                    <li class="divider"></li>

                    <li><a id='_efFormMenu_print' href="javascript:window.print();"><i class="ace-icon fa fa-print"></i>&nbsp;打印</a>
                    </li>

                    <li class="divider"></li>

                    <li><a id='_efFormMenu_diagnostics'
                           href="#">
                        <%--href="javascript:efform.openNewForm('EP31', 'methodName=initLoad&inqu_status-0-formEname=<%=encoder.encodeForHTMLAttribute(efFormEname)%>');">--%>
                        <i class="ace-icon fa fa-stethoscope"></i>&nbsp;页面诊断工具</a></li>
                    <li>
                        <a id='_efFormMenu_viewEiInfo'
                           href="#">
                            <%--<a id='_efFormMenu_viewEiInfo' href="javascript:efform.openNewForm('EP08');">--%>
                            <i class="ace-icon fa fa-info"></i>&nbsp;数据检查</a></li>

                    <li class="divider"></li>

                    <li><a id='_efFormMenu_favorites' href="javascript:favorites();"><i
                            class="ace-icon fa fa-bookmark"></i>&nbsp;收藏</a></li>
                </ul>
            </div>
        </div>

        <!-- 页面公用变量 -->
        <div id="efFormCommonValue" style='display: none'>
            <EF:EFInput blockId="" ename="efFormEname" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efFormCname" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efFormPopup" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efFormTime" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efCurFormEname" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efCurButtonEname" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="packageName" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="serviceName" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="methodName" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efFormInfoTag" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efFormLoadPath" row="" type="hidden"/>
            <EF:EFInput blockId="" ename="efFormButtonDesc" row="" type="hidden"/>

            <EF:EFInput blockId="" ename="__$$DIAGNOSE$$__" row="" type="hidden"/>

            <input type="hidden" id="efSecurityToken" name="efSecurityToken" value="<%=efSecurityToken%>"
                   class="inputField"/>
            <input type="hidden" id="COOKIE" name="COOKIE" value="<%=cookieStr%>"/>

        </div>
    </div>

    <!-- 状态提示行 -->
    <div class="ef-form-status">
    </div>

    <script type="text/javascript">
        var d_wnd = find_diagnose_window();
        if (d_wnd != null) {
            d_wnd.diagnose(3, null, window);
        }
        var _oldSetStatus = efform.setStatus;
        var _oldOnload = null;
        if (typeof efform_onload === "function") {
            _oldOnload = efform_onload;
        }

        setParentStatus = function (status_code, msg, msgKey) {
            _oldSetStatus(status_code, msg, msgKey);
            window.parent.efform.setStatus(status_code, msg, msgKey);
        }

        if (window.parent != window) { //是子页面
            if (window.parent.hideSubPageHead == true) {
                efform.hideFormHead();
                efform.setStatus = setParentStatus;
                //efform.getFormStatus() + ";MsgKey:" + efform.getMsgKey() + ";Msg:" + efform.getMsg()
                setParentStatus(efform.getFormStatus(), efform.getMsg(), efform.getMsgKey());
            }

            if (typeof window.parent.onSubPageLoad === "function") {
                efform_onload = function () {
                    if (typeof _oldOnload === "function") {
                        _oldOnload();
                    }
                    window.parent.onSubPageLoad(window);
                }
            }
        }
    </script>

    <script type="text/javascript">
        if (d_wnd != null) {
            var __oldOnload = null;
            if (typeof efform_onload === "function") {
                __oldOnload = efform_onload;
            }
            efform_onload = function () {
                var _oldEiSend = EiCommunicator.send;
                EiCommunicator.send = function (sService, sMethod, sEiInfo, sCallback, hasForm, ajaxMode) {
                    var newCallback = {
                        onSuccess: function (ajaxEi) {
                            d_wnd.diagnose(3, null, window);
                            if ((typeof( sCallback ) == "object") && (sCallback != null)) {
                                if (typeof( sCallback.onSuccess ) == "function") sCallback.onSuccess(ajaxEi);
                            }
                            d_wnd.diagnose(4, null, window);
                        },
                        onFail: function (msg, status, e) {
                            d_wnd.diagnose(3, null, window);
                            if (typeof( sCallback ) == "object") {
                                if (typeof( sCallback.onFail ) == "function") sCallback.onFail(msg, status, e);
                            }
                            d_wnd.diagnose(4, null, window);
                        }

                    };
                    _oldEiSend(sService, sMethod, sEiInfo, newCallback, hasForm, ajaxMode);
                }
                $("body").ajaxSend(function (evt, request, settings) {
                    d_wnd.diagnose(1, null, window, "Ajax调用");
                    var j = d_wnd.diagnose(2, null, window);
                    settings.data += "&__$$DIAGNOSE$$__=" + j.id;
// 				var _oldSuccess = settings.success;
// 				settings.success = function(msg) {
// 					d_wnd.diagnose(3, null, window);
// 					_oldSuccess(msg);
// 					d_wnd.diagnose(4, null, window);
// 				};
// 				var _oldError = settings.error;
// 				settings.error = function(xmlR, status, e) {
// 					d_wnd.diagnose(3, null, window);
// 					_oldError(xmlR, status, e);
// 					d_wnd.diagnose(4, null, window);
// 				}
                });
                if (typeof window.loadTabPage === "function") {
                    window.loadTabPage = function (index) {
                        var frame = frames[index];
                        var _p = path[index];
                        var j = d_wnd.diagnose(1, null, null, "加载TAB页面: [" + _p + "]");
                        _p += "&__$$DIAGNOSE$$__=" + j.id;
                        var _path = selected == null ? _p : composePath(frame, _p,
                                index);
                        if ($(frame).attr("__src") != _path) {
                            $(frame).attr("__src", _path);
                            frame.src = _path;
                            efform.setStatus(0, "正在加载...");
                        }
                        d_wnd.diagnose(2, j, null);
                    }
                }
                if (typeof __oldOnload === "function") {
                    __oldOnload();
                }
                d_wnd.diagnose_efform_onload(window);
            }
        }
    </script>
    <EF:EiInfo/>
    <!-- 页面内容 -->
    <jsp:doBody/>
</form>
<!-- 页面尾部 -->
<a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
    <i class="ace-icon fa fa-angle-double-up icon-only bigger-110"></i>
</a>
<%
    if (log != null) Diagnostics.end(log, null);
%>
</div>
<!-- <script type="text/javascript">
    var Main={};
    var Component=Vue.extend(Main);
    new Component().$mount("#app");
</script> -->
<!-- basic scripts -->

<!--[if !IE]> -->
<script type="text/javascript">
    window.jQuery || document.write("<script src='./ace/jQuery/jquery.min.js'>" + "<" + "/script>");
</script>

<!-- <![endif]-->

<!--[if IE]>
<script type="text/javascript">
    window.jQuery || document.write("<script src='./ace/jQuery/jquery1x.min.js'>" + "<" + "/script>");
</script>
<![endif]-->
<script type="text/javascript">
    if ('ontouchstart' in document.documentElement) document.write("<script src='./ace/jQuery/jquery.mobile.custom.min.js'>" + "<" + "/script>");
</script>
<script src="./ace/bootstrap/bootstrap.min.js"></script>

<!-- page specific plugin scripts -->
<script src="./ace/iplat-ui/iplat.ef.head.ace.js"></script>
<script src="./ace/iplat-ui/iplat.ui.form.ace.js"></script>

<!--[if lte IE 8]>
<script src="./ace/assets/js/excanvas.min.js"></script>
<![endif]-->
<% 
    String jsp_src = request.getServletPath();
    String js_src = jsp_src.substring(0, jsp_src.length() - 1); 
    %>
    <script type="text/javascript" src=".<%= js_src %>"></script>
<!-- ace scripts -->
<script src="./ace/assets/js/ace-elements.min.js"></script>
<script src="./ace/assets/js/ace.min.js"></script>

<!-- ace tooltip scripts -->
<script type="text/javascript">
    $(document).ready(function () {
        //初始化tooltip
        $('.ace-tooltip-link').tooltip();


        $('#_efFormMenu_diagnostics').addClass("ef-state-default").button().click(
                function (event) {
                    // 打开页面诊断工具
                    $('#efFormConfigMenu').hide();
                    efwindow.hide();
                    efform.openNewForm('EP31', 'methodName=initLoad&inqu_status-0-formEname=' +
                        __ei.attr.efFormEname);
                });
        $('#_efFormMenu_viewEiInfo').addClass("ef-state-default").button().click(function(event) {
            // 打开查看eiinfo的页面
            $('#efFormConfigMenu').hide();
            efwindow.hide();
            efform.openNewForm('EP08');
        });

    });
</script>

</body>