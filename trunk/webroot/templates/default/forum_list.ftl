<#include "header.ftl"/>
<link rel="alternate" type="application/rss+xml" title="RSS" href="${Request.forumdata.contextPath}/rss/recentTopics${Request.forumdata.extension}" />

<table width="100%" align="center">
	<tr>forum_list.ftl
	</tr>
	<tr>
		<td width="100%" height="318" valign="top">
			<table cellspacing="0" cellpadding="2" width="100%" align="center" border="0">
				<tr>
					<td valign="bottom" align="left">
						<#if Request.forumdata.logged><span class="gensmall">${Request.forumdata.I18n.getMessage("ForumListing.lastVisit")}: ${Request.forumdata.lastVisit}</span><br /></#if>
						<span class="gensmall">${Request.forumdata.I18n.getMessage("ForumListing.date")}: ${Request.forumdata.now}</span><br />
						<span class="forumlink"><a class="forumlink" href="${Request.forumdata.JForumContext.encodeURL("/forums/list.action")}">${Request.forumdata.I18n.getMessage("ForumListing.forumIndex")}</a></span>
					</td>
					<td class="gensmall" valign="bottom" align="right">&nbsp;
					<#if logged>
						<a class="gensmall" href="${Request.forumdata.JForumContext.encodeURL("/forums/newMessages")}">${Request.forumdata.I18n.getMessage("ForumListing.readLastVisitMessages")}</a>
					</#if>
					</td>
				</tr>
			</table>
			
			<table class="forumline" cellspacing="1" cellpadding="2" width="100%" border="0">
				<tr>
					<th class="thcornerl" nowrap="nowrap" colspan="2" height="25" align="center" valign="middle">&nbsp;${Request.forumdata.I18n.getMessage("ForumListing.forums")}&nbsp;</th>
					<th class="thtop" nowrap="nowrap" width="50">&nbsp;${Request.forumdata.I18n.getMessage("ForumListing.totalTopics")}&nbsp;</th>
					<th class="thtop" nowrap="nowrap" width="50">&nbsp;${Request.forumdata.I18n.getMessage("ForumListing.totalMessages")}&nbsp;</th>
					<th class="thcornerr" nowrap="nowrap">&nbsp;${Request.forumdata.I18n.getMessage("ForumListing.lastMessage")}&nbsp;</th>
				</tr>
		  
				<!-- START FORUM LISTING -->
				<#list Request.forumdata.allCategories as category>
					<tr>
						<td class="catleft" colspan="2" height="28"><span class="cattitle">${category.name}</span></td>
						<td class="catright" align="right" colspan="3">&nbsp;</td>
					</tr>

					<#list (category.takeForums()) as forum >
					
					<#assign lpi = forum.lastPostInfo />
					<tr>
						<td class="row1" valign="middle" align="center" height="50">
						<#if forum.unread>
							<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/folder_new_big.gif" alt="[New Folder]" />
						<#else>
							<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/folder_big.gif" alt="[Folder]" />
						</#if>
						</td>
						<td class="row1" width="100%" height="50">
							<span class="forumlink"><a class="forumlink" href="${Request.forumdata.JForumContext.encodeURL("/forums/show.action?fid=${forum.id}")}">${forum.name?html}</a></span><br />
							<span class="genmed">
								${forum.description?default("")}
								<#if forum.isModerated()><br />
								${Request.forumdata.I18n.getMessage("ForumIndex.moderators")}
								<#assign moderators = Request.forumdata.forumRepository.getModeratorList(forum.id)/>
								<#list moderators as m>
								  <a href="${Request.forumdata.JForumContext.encodeURL("/user/listGroup/${m.id}")}">${m.name?html}</a>
								</#list>
								</#if>
							</span>
							<br />		
						</td>
						<td class="row2" valign="middle" align="center" height="50"><span class="gensmall">${forum.totalTopics}</span></td>
						<td class="row2" valign="middle" align="center" height="50">
							<#assign total = forum.totalPosts/>
							<#if (total == 0 && forum.totalTopics > 0)>
								<#assign total = forum.totalTopics/>
							</#if>
							<span class="gensmall"><#if (total > 0)>${total}<#else>${Request.forumdata.I18n.getMessage("ForumListing.noMessages")}</#if></span>
						</td>
						<td class="row2" valign="middle" nowrap="nowrap" align="center" height="50">
							<span class="postdetails">
							<#if (lpi.postTimeMillis > 0)>
								${lpi.postDate}<br />
								<#if (lpi.userId > 0)><a href="${Request.forumdata.JForumContext.encodeURL("/user/profile/${lpi.userId}")}"></#if>${lpi.username}</a> 
					
								<#assign startPage = ""/>
								<#if (lpi.topicReplies + 1 > Request.forumdata.topicsPerPage)>
									<#assign startPage = ((lpi.topicReplies / Request.forumdata.topicsPerPage)?int * Request.forumdata.topicsPerPage) +"/"/>
								</#if>
					
								<#assign url = Request.forumdata.JForumContext.encodeURL("/posts/list/${startPage}${lpi.topicId}") + "#" + lpi.postId/>
								<a href="${url}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_latest_reply.gif" border="0" alt="[Latest Reply]" /></a>
							<#else>
								${Request.forumdata.I18n.getMessage("ForumListing.noMessages")}
							</#if>		
							</span>		
						</td>
					</tr>
					</#list>
				</#list>		
				<!-- END OF FORUM LISTING -->
			</table>
		
			<table cellspacing="0" cellpadding="2" width="100%" align="center" border="0">
				<tr>
					<td align="left"><span class="gensmall"><a class="gensmall" href="">&nbsp;</a></span><span class="gensmall">&nbsp;</span></td>
				</tr>
			</table>
		
			<table class="forumline" cellspacing="1" cellpadding="3" width="100%" border="0">
				<tr>
					<td class="cathead" colspan="2" height="28"><span class="cattitle">${Request.forumdata.I18n.getMessage("ForumListing.whoIsOnline")}</span></td>
				</tr>

				<tr>
					<td class="row1" valign="middle" align="center" rowspan="2"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/whosonline.gif" alt="[Who's Online]"/></td>
					<td class="row1 gensmall" align="left" width="100%">
						${Request.forumdata.I18n.getMessage("ForumListing.totalMessagesInfo", [ Request.forumdata.totalMessages ])}<br />
						${Request.forumdata.I18n.getMessage("ForumListing.registeredUsers", [ Request.forumdata.totalRegisteredUsers ])}<br />
						${Request.forumdata.I18n.getMessage("ForumListing.newestUser")} <a href="${Request.forumdata.JForumContext.encodeURL("/user/profile/${Request.forumdata.lastUser.id}")}">${Request.forumdata.lastUser.username}</a>
					</td>
				</tr>

				<tr>
					<td class="row1 gensmall" align="left">
						<#assign adminColor = "class='admin'"/>
						<#assign moderatorColor = "class='moderator'"/>
						<#assign color = ""/>

						${Request.forumdata.I18n.getMessage("ForumListing.numberOfUsersOnline", [ Request.forumdata.totalOnlineUsers, Request.forumdata.totalRegisteredOnlineUsers, Request.forumdata.totalAnonymousUsers ])}&nbsp;&nbsp;
			
						[ <span ${adminColor}>${Request.forumdata.I18n.getMessage("Administrator")}</span> ]&nbsp;[ <span ${moderatorColor}>${Request.forumdata.I18n.getMessage("Moderator")}</span> ]
						<br />
						${Request.forumdata.I18n.getMessage("ForumListing.mostUsersEverOnline", [Request.forumdata.mostUsersEverOnline.getTotal(), Request.forumdata.mostUsersEverOnline.getDate()?string ])}									
						<br />
						${Request.forumdata.I18n.getMessage("ForumListing.connectedUsers")}: 
			
						<#list Request.forumdata.userSessions as us>
							<#if us.isAdmin()>
								<#assign color = adminColor/>
							<#elseif us.isModerator()>
								<#assign color = moderatorColor/>
							<#else>
								<#assign color = ""/>
							</#if>

								<a href="${Request.forumdata.JForumContext.encodeURL("/user/profile/${us.userId}")}"><span ${color}>${us.username}</span></a>&nbsp;
						</#list>			
					</td>
				</tr>
			</table>
			
			<br />
        
			<#if !Request.forumdata.logged && !Request.forumdata.sso>
			<#include "showlogin.ftl"/>
			</#if>

			<table cellspacing="3" cellpadding="0" align="center" border="0">
				<tr>
					<td align="center" width="20"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/folder_new.gif" alt="[New Folder]" /></td>
					<td><span class="gensmall">${Request.forumdata.I18n.getMessage("ForumListing.newMessages")}</span></td>
					<td>&nbsp;&nbsp;</td>
					<td align="center" width="20"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/folder.gif" alt="[Folder]" /></td>
					<td><span class="gensmall">${Request.forumdata.I18n.getMessage("ForumListing.noNewMessages")}</span></td>
					<td>&nbsp;&nbsp;</td>
					<td align="center" width="20"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/folder_lock.gif" alt="[Lock Folder]" /></td>
					<td><span class="gensmall">${Request.forumdata.I18n.getMessage("ForumListing.blocked")}</span></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<#include "bottom.htm"/>
