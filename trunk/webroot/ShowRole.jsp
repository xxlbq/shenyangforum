<%@page contentType="text/html;charset=UTF-8"%> 
<%@taglib prefix="s" uri="/struts-tags"%> 
<html> 
<head> 
    <title> Authorizated User </title> 
</head>
<body>
<h1>Your role is:<s:property value="role"/></h1>

    <s:form action ="clearRole" > 
        
        <s:submit value="clear" /> 
    </s:form > 
</body>
</html>