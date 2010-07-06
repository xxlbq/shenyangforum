<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
    <head>
        <title>Say Hello</title>
    </head>
    <body>
        <h3>Say "Hello" to: </h3>
        <s:form action="HelloWorld">
            1  Name: <s:textfield name="name" />
            <s:submit />
        </s:form>
        
        
        <s:form action="AliasHelloWorld">
            2  Name: <s:textfield name="name" />
            <s:submit />
        </s:form>
        
        <s:form action="HelloWorld!aliasAction">
            3  Name: <s:textfield name="name" />
            <s:submit />
        </s:form>
        
        
		<s:form action="VMHelloWorld">
            4  velocity: <s:textfield name="name" />
            <s:submit />
        </s:form>
        
    </body>
</html>