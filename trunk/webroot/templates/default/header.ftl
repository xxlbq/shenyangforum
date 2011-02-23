<#setting number_format = "#"/>
<#setting datetime_format = Request.forumdata.dateTimeFormat/>
<#assign logged = Request.forumdata.logged?default(false)/>
<#assign language = Request.forumdata.language?default("en_US")/>
<#assign hasCodeBlock = Request.forumdata.hasCodeBlock?default(false)/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=${Request.forumdata.encoding}" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="-1" />
<style type="text/css">@import url( ${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/styles/style.css?${Application.startupTime} );</style>
<style type="text/css">@import url( ${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/styles/${Request.forumdata.language}.css?${Application.startupTime} );</style>

<#if hasCodeBlock>
	<style type="text/css">@import url( ${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/styles/SyntaxHighlighter.css?${Application.startupTime} );</style>
</#if>

<title>${Request.forumdata.pageTitle?default("JForum")?html}</title>

</head>
<body class="${Request.forumdata.language}">

<!--
Original theme from phpBB (http://www.phpbb.com) subSilver
Created by subBlue design
http://www.subBlue.com

Modifications by JForum Team
-->

<table width="100%" border="0">
	<tr>
	header.ftl
	</tr>
	<tr>
		<td>
			<table cellspacing="0" cellpadding="0" width="100%" border="0">
				<tr>
					<td>
						<a href="${Request.forumdata.homepageLink}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/logo.jpg"  vspace="1" border="0" alt="[Logo]" /></a>
					</td>
					 
					<td width="100%" align="center" valign="middle">
						<span class="boardtitle">${Request.forumdata.forumTitle?default("JForum")}</span>
						<table cellspacing="0" cellpadding="2" border="0">
							<tr>
								<td valign="top" nowrap="nowrap" align="center">&nbsp;
									<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_search.gif" alt="[Search]"/>
									<span class="mainmenu"><a id="search" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/search/filters")}"><b>${Request.forumdata.I18n.getMessage("ForumBase.search")}</b></a> &nbsp;
									
									<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_recentTopics.gif" alt="[Recent Topics]" />
									<a id="latest" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/recentTopics/list")}">${Request.forumdata.I18n.getMessage("ForumBase.recentTopics")}</a> &nbsp;
									<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_recentTopics.gif" alt="[Hottest Topics]" />
									<a id="hottest" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/hottestTopics/list")}">${Request.forumdata.I18n.getMessage("ForumBase.hottestTopics")}</a> &nbsp;
									<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_members.gif" alt="[Members]" />&nbsp;
									<a id="latest2" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/user/list")}">${Request.forumdata.I18n.getMessage("ForumBase.usersList")}</a> &nbsp;
									<span class="mainmenu"> <img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_groups.gif" alt="[Groups]" />&nbsp;<a id="backtosite" class="mainmenu" href="${Request.forumdata.homepageLink}">${Request.forumdata.I18n.getMessage("ForumBase.backToSite")}</a>&nbsp;
									
									<br>

									<#if canAccessModerationLog?default(false)>
										<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_members.gif" alt="[Moderation Log]" />
										<a id="moderationlog" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/moderation/showActivityLog")}">${Request.forumdata.I18n.getMessage("ModerationLog.moderationLog")}</a> &nbsp;
									</#if>

									<#if logged>
										<a id="myprofile" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/user/edit/${Request.forumdata.session.userId}")}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_profile.gif" border="0" alt="[Profile]" /> ${Request.forumdata.I18n.getMessage("ForumBase.profile")}</a>&nbsp; 
										<#if Request.forumdata.bookmarksEnabled>
											<a class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/bookmarks/list/${Request.forumdata.session.userId}")}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_minipost.gif" alt="[Post]" />${Request.forumdata.I18n.getMessage("Bookmarks.myBag")}</a>&nbsp;
										</#if>
										<a id="privatemessages" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/pm/inbox")}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_message.gif" border="0" alt="[Message]" />
											<#if (Request.forumdata.session.privateMessages > 0)>
												${Request.forumdata.I18n.getMessage("ForumBase.newPm")}: (${Request.forumdata.session.privateMessages})
											<#else>
												${Request.forumdata.I18n.getMessage("ForumBase.privateMessages")}
											</#if>
										</a>&nbsp;
										</span>

										<#if ! Request.forumdata.sso>
											<a id="logout" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/user/logout")}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_login.gif" border="0" alt="[Login]" /> ${Request.forumdata.I18n.getMessage("ForumBase.logout")} [${Request.forumdata.session.username}] </a></span>
										</#if>
									</#if>
	
									<#if !Request.forumdata.logged && !Request.forumdata.sso>
										<a id="register" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/user/insert")}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_register.gif" border="0" alt="[Register]" /> ${Request.forumdata.I18n.getMessage("ForumBase.register")}</a>&nbsp;/&nbsp;</span>
										<a id="login" class="mainmenu" href="${Request.forumdata.JForumContext.encodeURL("/user/login.action")}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_login.gif" border="0" alt="[Login]" /> ${Request.forumdata.I18n.getMessage("ForumBase.login")}</a>&nbsp; </span>
										
									</#if>

									
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>

