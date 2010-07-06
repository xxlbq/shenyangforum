<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
    <title>Login</title>
</head>
<body>
<P>1</P>

<s:form action="Login" method="POST">
    <s:textfield name="name" label="User name"/>
    <s:password name="password" label="Password"/>
    <s:submit value="Submit"/>
</s:form>

<P>2</P>

<s:form action="LoginX" method="POST">
    <s:textfield name="user.name" label="User name"/>
    <s:password name="user.password" label="Password"/>
    <s:submit value="Submit"/>
</s:form>

<br/>
   Please select a role below:
    <s:bean id ="roles" name ="tutorial.Roles" /> 
    <s:form action ="InterceptorLogin" > 
        <s:radio list ="#roles.roles" value ="'EMPLOYEE'" name ="role" label ="Role" /> 
        <s:submit /> 
    </s:form > 


</body>
</html>