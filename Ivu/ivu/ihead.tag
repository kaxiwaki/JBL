<%@ tag language="java" pageEncoding="UTF-8" 
%><%@ taglib prefix="e5" tagdir="/WEB-INF/tags/e5" 
%><%@ tag import="org.apache.commons.lang.StringUtils" %>

<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<meta charset="utf-8" />
	
	<meta name="description" content="overview &amp; stats" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

	<link rel="icon"  href="iplat.ico"  type="image/x-icon"/>	
	<link rel="SHORTCUT ICON"  href="iplat.ico"  type="image/x-icon"/>	
	
	<!-- bootstrap & fontawesome 
	<e5:css id="bootstrap"/>
	<e5:css id="font-awesome"/>
-->

	<link rel="stylesheet" type="text/css" media="screen" href="smart/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" media="screen" href="smart/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" media="screen" href="smart/css/font-awesome.css">
	<link rel="stylesheet" type="text/css" href="ivu/css/ionicons.min.css">
	<!-- page specific plugin styles -->
 	<!-- 
 	<e5:asset file="ace/assets/css/jquery-ui.css" type="css"/>
 	-->
  	
	<!-- text fonts -->
	<e5:asset file="ace/assets/css/ace-fonts.css" type="css"/>
	
	<!-- ace styles -->
	<!-- <e5:asset file="ace/assets/css/ace.css" type="css"/> -->
	
	<!-- self styles -->
	
	<!--[if lte IE 9]>
		<e5:asset file="ace/assets/css/ace-part2.min.css" type="css"/>
	<![endif]-->
	<!-- <e5:asset file="ace/assets/css/ace-skins.min.css" type="css"/> -->
	<!-- <e5:asset file="ace/assets/css/ace-rtl.min.css" type="css"/> -->
	
	<!--[if lte IE 9]>
	  <e5:asset file="ace/assets/css/ace-ie.min.css" type="css"/>
	<![endif]-->
	
	<!-- inline styles related to this page -->
	<e5:asset file="ace/iplat-ui/css/iplat-ui-5.0.css" type="css"/>
	<% String cssPath = "styleApple/Grey"; %>
	<link href='./ace/lib/jquery-ui/jquery-ui-1.8.22.custom.css' rel='stylesheet' type='text/css' />
	<link href='./EF/Themes/<%= cssPath %>/jquery-ui.custom.css' rel='stylesheet' type='text/css' />
	<link href='./EF/Themes/<%= cssPath %>/iplat-ui-theme-2.0.css' rel='stylesheet' type='text/css' />
	<!-- <link href="./ace/iplat-ui/iplat-ui-ace.css" rel="stylesheet" type='text/css'/> -->

	<!-- ace settings handler -->
	<!-- <e5:asset file="ace/assets/js/ace-extra.min.js" type="js"/> -->
	<%--<e5:asset file="smart/js/smart.js" type="js"/>--%>

	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	
	<!--[if lte IE 8]>
	<e5:asset file="ace/assets/js/html5shiv.js" type="js"/>
	<e5:asset file="ace/assets/js/respond.min.js" type="js"/>
	<![endif]-->
	<%--<e5:asset file="smart/css/ace2.css" type="css"/>--%>
	<e5:asset file="ivu/css/iview.css" type="css"/>
	<!-- <script type="text/javascript" src="./ace/iplat-ui/iplat-ui-ace.js"></script> -->
	<script type="text/javascript" src="ivu/js/vue.min.js"></script>
	<script type="text/javascript" src="ivu/js/iview.min.js"></script>
	<jsp:doBody/>

	<!-- <% 
	String jsp_src = request.getServletPath();
	String js_src = jsp_src.substring(0, jsp_src.length() - 1); 
	%>
	<script type="text/javascript" src=".<%= js_src %>"></script> -->

</head>