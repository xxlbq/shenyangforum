<html>
<head>

<#assign contextPath = Request.forumdata.contextPath>
<#assign templateName = Request.forumdata.templateName>

<#assign I18n = Request.forumdata.I18n>
<#assign encoding = Request.forumdata.encoding>
<#assign pageTitle = Request.forumdata.pageTitle>
<#assign posts = Request.forumdata.posts>
<#assign users = Request.forumdata.users>


<meta http-equiv="Content-Type" content="${encoding}"/>
<title>${pageTitle}</title>
<style type="text/css">@import url( ${contextPath}/templates/${templateName}/styles/style.css?${startupTime} );</style>
<script type="text/javascript" src="${contextPath}/templates/${templateName}/js/jquery.js?${startupTime}"></script>
<script type="text/javascript" src="${contextPath}/templates/${templateName}/js/post.js?${startupTime}"></script>

<#if hasCodeBlock?default(false)>
	<style type="text/css">@import url( ${contextPath}/templates/${templateName}/styles/SyntaxHighlighter.css?${startupTime} );</style>
</#if>
</head>

<body bgcolor="#FFFFFF" text="#000000" link="#01336B" vlink="#01336B">
<span class="gen"><a name="top"></a></span>

<table border="0" cellpadding="3" cellspacing="1" width="100%" class="forumline">
	<tr>
		<th class="thcornerl" width="150" height="26">${I18n.getMessage("PostShow.author")}</th>
		<th class="thcornerr">${I18n.getMessage("PostShow.messageTitle")}</th>
	</tr>

	<#list posts as post>
		<#if post_index % 2 == 0>
			<#assign rowColor = "row1">
		<#else>
			<#assign rowColor = "row2">
		</#if>

		<#assign user = users.get(post.userId)/>

		<tr>
			<td align="left" valign="top" class="row1">
				<span class="name"><b>${user.username}</b></span>
			</td>
			
			<td class="row1" height="28" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="100%">
							<img src="${contextPath}/templates/${templateName}/images/icon_minipost.gif" width="12" height="9" border="0" alt="Post" />
							<span class="postdetails">${post.formatedTime}
							<span class="gen">&nbsp;</span>&nbsp;&nbsp;&nbsp;${I18n.getMessage("PostShow.subject")}: ${post.subject?default("")?html} </span>
						</td>
					</tr>
					<tr>
						<td colspan="2"><hr /></td>
					</tr>
					<tr>
						<td colspan="2">
							<span class="postbody">${post.text}</span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td colspan="2" height="1" class="spacerow"><img src="${contextPath}/templates/${templateName}/images/spacer.gif" alt="" width="1" height="1" /></td>
		</tr>
	</#list>
</table>

<script type="text/javascript">
limitURLSize();
</script>

<#if hasCodeBlock?default(false)>
	<#include "highligther_js.htm"/>
</#if>

</body>
</html>