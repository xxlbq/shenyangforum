<#include "header.ftl"/>

<#import "../macros/pagination.ftl" as pagination>
<#import "../macros/presentation.ftl" as presentation/>

<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/pagination.js?${startupTime}"></script>

<#if Request.forumdata.logged>
	<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/watch.js?${Request.forumdata.startupTime}"></script>
</#if>

<#if Request.forumdata.moderator>
	<script type="text/JavaScript" src="${Request.forumdata.JForumContext.encodeURL("/js/list/moderation")}"></script>
</#if>

<table cellspacing="0" cellpadding="10" width="100%" align="center" border="0">
	<tr>
		<td class="bodyline" valign="top">
			<table cellspacing="2" cellpadding="2" width="100%" align="center">
				<tr>
					<td valign="bottom" align="left" colspan="2">
						<a class="maintitle" href="${Request.forumdata.JForumContext.encodeURL("/forums/list")}">${Request.forumdata.I18n.getMessage("ForumListing.forumIndex")}</a> &raquo;
						<a class="maintitle" href="${Request.forumdata.JForumContext.encodeURL("/forums/show.action?fid=${Request.forumdata.forum.id}")}">${Request.forumdata.forum.name?html}</a>

						<#if Request.forumdata.rssEnabled>
							<a href="${Request.forumdata.JForumContext.encodeURL("/rss/forumTopics/${Request.forumdata.forum.id}")}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/xml_button.gif" border="0" alt="[XML]" /></a>
							<br />
						</#if>
					</td>

					<td valign="middle"  nowrap="nowrap" align="right" class="gensmall">
						<#if Request.forumdata.logged>
							<a href="${Request.forumdata.JForumContext.encodeURL("/forums/readAll/${Request.forumdata.forum.id}")}">${Request.forumdata.I18n.getMessage("ForumIndex.setAllTopicsAsRead")}</a>
						</#if>

						<#if Request.forumdata.moderator>
							<br />

							<#if Request.forumdata.openModeration?default(false)>
								<#assign link = ""/>
								<#if (start > 0)>
									<#assign link = Request.forumdata.JForumContext.encodeURL("/forums/show/" + start + "/" + forum.id)/>
								<#else>
									<#assign link = Request.forumdata.JForumContext.encodeURL("/forums/show/" + forum.id)/>
								</#if>
								<a href="${link}">${Request.forumdata.I18n.getMessage("Moderation.CloseModeration")}</a>
							<#else>
								<a href="${Request.forumdata.contextPath}/forums/moderation/<#if (Request.forumdata.start > 0)>${start}/</#if>${Request.forumdata.forum.id}${Request.forumdata.extension}">${Request.forumdata.I18n.getMessage("Moderation.OpenModeration")}</a>
							</#if>
						</#if>
					</td>
				</tr>
			</table>

			<table cellspacing="2" cellpadding="2" width="100%" align="center">
				<tr>
					<#if !Request.forumdata.readonly && !Request.forumdata.replyOnly>
						<td valign="middle" align="left" width="50">
							<a href="${Request.forumdata.JForumContext.encodeURL("/jforum${Request.forumdata.extension}?module=posts&amp;action=insert&amp;forum_id=${Request.forumdata.forum.id}", "")}" rel="nofollow" class="icon_new_topic"><img src="${Request.forumdata.contextPath}/images/transp.gif" alt="" /></a>
						</td>
					</#if>

					<form accept-charset="${Request.forumdata.encoding}" action="${Request.forumdata.JForumContext.encodeURL("/jforum")}" method="get" id="formSearch" name="formSearch">
					<input type="hidden" name="module" value="search"/>
					<input type="hidden" name="action" value="search"/>
					<input type="hidden" name="forum" value="${Request.forumdata.forum.id}">
					<input type="hidden" name="match_type" value="all">

					<td class="nav" valign="middle" align="left" colspan="${Request.forumdata.colspan?default("")}">
						<input type="text" onblur="if (this.value == '') this.value = '${Request.forumdata.I18n.getMessage("ForumIndex.searchThisForum")}...';" onclick="if (this.value == '${Request.forumdata.I18n.getMessage("ForumIndex.searchThisForum")}...') this.value = '';" value="${Request.forumdata.I18n.getMessage("ForumIndex.searchThisForum")}..." size="20" name="search_keywords" class="inputSearchForum"/>
						<input type="submit" value="${Request.forumdata.I18n.getMessage("ForumBase.search")}" class="liteoption">
					</td>

					</form>

					<td class="nav" nowrap="nowrap" align="right">
		  				<#assign paginationData><@pagination.doPagination action, Request.forumdata.forum.id/></#assign>
						${paginationData}
					</td>
				</tr>
			</table>

			<#if (Request.forumdata.canApproveMessages && Request.forumdata.topicsToApprove.size() > 0)>
				<script type="text/javascript">
				<!--
				function viewPending(id)
				{
					var tr = document.getElementById("tr_pending_" + id);
					var d = tr.style.display
					tr.style.display = (d == "none" ? "" : "none");
				}
				-->
				</script>
				<form action="${Request.forumdata.JForumContext.encodeURL("/jforum")}" method="post" accept-charset="${encoding}">
				<input type="hidden" name="action" value="approveMessages" />
				<input type="hidden" name="module" value="${Request.forumdata.moduleName}" />
				<input type="hidden" name="forum_id" value="${Request.forumdata.forum.id}" />

				<table width="70%"class="forumline" align="center" cellspacing="1" cellpadding="4">
					<tr>
						<td class="bg_yellow" align="center" style="height: 30px" colspan="2"><span class="gensmal" style="font-size: 11px; "><b>${Request.forumdata.I18n.getMessage("Moderation.checkQueue")}</b></span></td>
					</tr>

					<#list topicsToApprove.values() as topic>
						<#if topic_index % 2 == 0>
							<#assign rowColor = "">
						<#else>
							<#assign rowColor = "bg_small_yellow">
						</#if>

						<tr class="${Request.forumdata.rowColor}">
							<td width="90%">
								<#if (topic.topicReplies > 0)>
									<a href="${Request.forumdata.JForumContext.encodeURL("/posts/list/postList.action?topicId=${topic.topicId}")}" class="gen">${topic.topicTitle?html}</a>
								<#else>
									<span class="gen">${topic.topicTitle?html}</span>
								</#if>
							</td>
							<td align="center"><span class="gen"><a href="javascript:viewPending(${topic.topicId});"><b>${Request.forumdata.I18n.getMessage("Moderation.Admin.view")}</b></a></span></td>
						</tr>

						<!-- Messages -->
						<tr id="tr_pending_${topic.topicId}" style="display: none">
							<td colspan="2">
								<table width="95%" align="right">
									<#list topic.posts as post>
										<#assign post = postFormatter.preparePostForDisplay(post)/>

										<tr><td><span class="gensmall"><b>${Request.forumdata.I18n.getMessage("PostShow.author")}</b>: <a href="${Request.forumdata.JForumContext.encodeURL("/user/profile/${post.userId}")}">${post.postUsername}</a></span></td></tr>
										<tr><td><span class="gensmall">${post.text}</span></td></tr>

										<tr>
											<td colspan="2" align="right">
												<span class="gensmall">
													<input type="radio" id="status_approve_${post.id}" name="status_${post.id}" value="aprove" /><label for="status_approve_${post.id}">${Request.forumdata.I18n.getMessage("Moderation.Admin.aprove")}</label>&nbsp;
													<input type="radio" id="status_defer_${post.id}" name="status_${post.id}" value="defer" checked="checked" /><label for="status_defer_${post.id}">${Request.forumdata.I18n.getMessage("Moderation.Admin.defer")}</label>&nbsp;
													<input type="radio" id="status_deny_${post.id}" name="status_${post.id}" value="reject" /><label for="status_deny_${post.id}">${Request.forumdata.I18n.getMessage("Moderation.Admin.reject")}</label>&nbsp;
													<input type="hidden" name="post_id" value="${post.id}" />
												</span>
											</td>
										</tr>

										<#if (post_index + 1 < topic.posts.size())>
											<tr>
												<td colspan="2" height="1" class="spacerow"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/spacer.gif" alt="" width="1" height="1" /></td>
											</tr>
										</#if>
									</#list>
								</table>
							</td>
						</tr>
					</#list>

					<!-- Submit -->
					<tr>
						<td colspan="2" align="center"><input type="submit" class="mainoption" value="${Request.forumdata.Request.forumdata.I18n.getMessage("Moderation.Admin.submit")}" /></td></tr>
					</tr>
				</table>
				</form>
			</#if>

			<#if Request.forumdata.moderator>
				<form action="${Request.forumdata.JForumContext.encodeURL("/jforum")}" method="post" name="formModeration" id="formModeration" accept-charset="${encoding}">
				<input type="hidden" name="action" value="doModeration" />
				<input type="hidden" name="module" value="moderation" />
				<input type="hidden" name="returnUrl" value="${Request.forumdata.JForumContext.encodeURL("/${Request.forumdata.moduleName}/${Request.forumdata.action}/${Request.forumdata.start}/${forum.id}")}" />
				<input type="hidden" name="forum_id" value="${forum.id}" />
				<input type="hidden" name="log_type" value="0"/>
				<input type="hidden" name="log_description">
			</#if>

			<table class="forumline" cellspacing="1" cellpadding="4" width="100%" border="0">
				<tr>
					<th class="thcornerl" nowrap="nowrap" align="center" colspan="2" height="25">&nbsp;${Request.forumdata.I18n.getMessage("ForumIndex.topics")}&nbsp;</th>
					<th class="thtop" nowrap="nowrap" align="center" width="50">&nbsp;${Request.forumdata.I18n.getMessage("ForumIndex.answers")}&nbsp;</th>
					<th class="thtop" nowrap="nowrap" align="center" width="100">&nbsp;${Request.forumdata.I18n.getMessage("ForumIndex.author")}&nbsp;</th>
					<th class="thtop" nowrap="nowrap" align="center" width="50">&nbsp;${Request.forumdata.I18n.getMessage("ForumIndex.views")}&nbsp;</th>
					<th class="thcornerr" nowrap="nowrap" align="center">&nbsp;${Request.forumdata.I18n.getMessage("ForumIndex.lastMessage")}&nbsp;</th>

					<#if Request.forumdata.moderator && Request.forumdata.openModeration?default(false)>
						<th class="thcornerr" nowrap="nowrap" align="center">&nbsp;${Request.forumdata.I18n.getMessage("ForumIndex.moderation")}&nbsp;</th>
					</#if>
				</tr>

				<!-- TOPICS LISTING -->
				<#list Request.forumdata.topics as topic>
					<#assign class1>class="<@presentation.row1Class topic/>"</#assign>
					<#assign class2>class="<@presentation.row2Class topic/>"</#assign>
					<#assign class3>class="<@presentation.row3Class topic/>"</#assign>

					<#if Request.forumdata.canApproveMessages>
						<#if Request.forumdata.topicsToApprove.containsKey(topic.id)>
							<#assign class1 = "class='bg_yellow'"/>
							<#assign class2 = class1/>
							<#assign class3 = class1/>
						</#if>
					</#if>

					<tr class="bg_small_yellow">
						<td ${class1} valign="middle"  align="center" width="20"><@presentation.folderImage topic/></td>
						<td ${class1} width="100%">
							<#if topic.hasAttach() && attachmentsEnabled><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_clip.gif" align="middle" alt="[Clip]" /></#if>
							<span class="topictitle">
							<a href="${Request.forumdata.JForumContext.encodeURL("/post/postList.action?topic_id=${topic.id}")}">
							<#if topic.vote>${Request.forumdata.I18n.getMessage("ForumListing.pollLabel")}</#if>
							<#if (topic.title?length == 0)>
								No Subject
							<#else>
								${topic.title?html}
							</#if>
							</a>
							</span>

							<#if topic.paginate>
								<span class="gensmall">
								<br />
								<@pagination.littlePostPagination topic.id, postsPerPage, topic.totalReplies/>
								</span>
							</#if>
						</td>

						<td ${class2} valign="middle"  align="center"><span class="postdetails">${topic.totalReplies}</span></td>
						<td ${class3} valign="middle"  align="center">
							<span class="name"><a href="${Request.forumdata.JForumContext.encodeURL("/user/profile/${topic.postedBy.id}")}">${topic.postedBy.username}</a></span>
						</td>

						<td ${class2} valign="middle"  align="center"><span class="postdetails">${topic.totalViews}</span></td>
						<td ${class3} valign="middle"  nowrap="nowrap" align="center">
							<#if (topic.lastPostTime?length > 0)>
								<span class="postdetails">${topic.lastPostTime}<br />
								<a href="${Request.forumdata.JForumContext.encodeURL("/user/profile/${topic.lastPostBy.id}")}">${topic.lastPostBy.username}</a>

								<#assign startPage = ""/>
								<#if (topic.totalReplies + 1 > Request.forumdata.postsPerPage?number)>
									<#assign startPage = ((topic.totalReplies / Request.forumdata.postsPerPage?number)?int * Request.forumdata.postsPerPage?number) +"/"/>
								</#if>

								<a href="${Request.forumdata.JForumContext.encodeURL("/posts/list/${startPage}${topic.id}")}#${topic.lastPostId}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_latest_reply.gif" border="0" alt="[Latest Reply]" /></a></span>
							</#if>
						</td>

						<#if Request.forumdata.moderator && Request.forumdata.openModeration?default(false)>
							<td ${class2} valign="middle" align="center">
								<input type="checkbox" <#if topic.movedId != 0 && topic.forumId != forum.id>disabled="disabled"</#if> name="topic_id" value="${topic.id}" onclick="changeTrClass(this, ${topic_index});"/>
							</td>
						</#if>
					</tr>
				</#list>
				<!-- END OF TOPICS LISTING -->
				
				<tr align="center">
					<td class="catbottom" valign="middle"  align="right" colspan="<#if Request.forumdata.moderator && Request.forumdata.openModeration?default(false)>7<#else>6</#if>" height="28">
						<table cellspacing="0" cellpadding="0" border="0">
							<tr>
								<td align="center"><span class="gensmall">&nbsp;<@presentation.moderationButtons/></span></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			
			<#if Request.forumdata.moderator></form></#if>	

			<table cellspacing="2" cellpadding="2" width="100%" align="center" border="0">
				<tr>
					<#if !Request.forumdata.readonly && !Request.forumdata.replyOnly>
						<td valign="middle"  align="left" width="50">
							<a href="${Request.forumdata.JForumContext.encodeURL("/jforum${Request.forumdata.extension}?module=posts&amp;action=insert&amp;forum_id=${Request.forumdata.forum.id}","")}" rel="nofollow" class="icon_new_topic"><img src="${Request.forumdata.contextPath}/images/transp.gif" alt="" /></a>
						</td>
					<#else>
						<#assign colspan = "2"/>
					</#if>

					<td valign="middle"  align="left" colspan="${colspan?default("0")}">
						<span class="nav">
						<a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/list")}">${Request.forumdata.I18n.getMessage("ForumListing.forumIndex")}</a> &raquo;  <a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/show/${Request.forumdata.forum.id}")}">${Request.forumdata.forum.name?html}</a></span>
					</td>

					<td nowrap="nowrap" align="right" class="nav">${paginationData}</td>
				</tr>

				<tr>
					<td align="left" colspan="3"><span class="nav"></span></td>
				</tr>
			</table>

			<table cellspacing="0" cellpadding="5" width="100%" border="0">
				<tr>
					<td align="left" class="gensmall">
						<#if Request.forumdata.logged>
							<#if !Request.forumdata.watching>
								<#assign watchMessage = Request.forumdata.I18n.getMessage("ForumShow.watch")/>
								<a href="#watch" onClick="watchForum('${Request.forumdata.JForumContext.encodeURL("/forums/watchForum/${Request.forumdata.forum.id}")}', '${Request.forumdata.I18n.getMessage("ForumShow.confirmWatch")}');">
							<#else>
								<#assign watchMessage = Request.forumdata.I18n.getMessage("ForumShow.unwatch")/>
								<a href="${Request.forumdata.JForumContext.encodeURL("/forums/unwatchForum/${Request.forumdata.forum.id}")}">
							</#if>
							<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/watch.gif" align="middle" alt="Watch" />&nbsp;${watchMessage}</a>
						</#if>
					</td>
					<td align="right"><@presentation.forumsComboTable/></td>
				</tr>
			</table>

			<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
				<tr>
					<td valign="top" align="left">
						<#include "folder_descriptions.htm"/>
					</td>


				</tr>
			</table>
		</td>
	</tr>
</table>

<#include "bottom.htm"/>
