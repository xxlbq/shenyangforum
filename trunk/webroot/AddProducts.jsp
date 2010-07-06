<%@ page  contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
<div style="color:red">
    <s:fielderror />
</div>
    <s:form action="ProductConfirm" theme="simple">            
        <table>
            <tr style="background-color:powderblue; font-weight:bold;">
                <td>Product Name</td>
                <td>Price</td>
                <td>Date of production</td>
            </tr>
            <s:iterator value="new int[1]" status="stat">
                <tr>
                    <td><s:textfield name="%{'products['+#stat.index+'].name'}" /></td>
                    <td><s:textfield name="%{'products['+#stat.index+'].price'}" /></td>
                    <td><s:textfield name="%{'products['+#stat.index+'].dateOfProduction'}" /></td>
                </tr>
            </s:iterator>
            <tr>
                <td colspan="3"><s:submit /></td>
            </tr>
        </table>
    </s:form>    
</body>
</html>