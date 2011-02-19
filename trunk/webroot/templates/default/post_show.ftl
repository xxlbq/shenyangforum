<#include "header.ftl"/>
<#import "../macros/pagination.ftl" as pagination/>
<#import "../macros/presentation.ftl" as presentation/>

<#assign canEditSomeMessage = false/>

<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/jquery.js?${startupTime}"></script>
<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/jquery.jeditable.pack.js?${startupTime}"></script>
<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/post_show.js?${startupTime}"></script>
<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/post.js?${startupTime}"></script>
<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/pagination.js?${startupTime}"></script>

<#if logged>
	<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/watch.js?${startupTime}"></script>
</#if>

<script type="text/javascript">
<!--
<#include "js/karma.js">
<#include "js/utils.js"/>

<#if Request.forumdata.canRemove || Request.forumdata.isModerator || Request.forumdata.isAdmin>
	function confirmDelete(postId)
	{
		if (confirm("${Request.forumdata.I18n.getMessage("Moderation.ConfirmPostDelete")}")) {
			var reason = prompt("${I18n.getMessage("ModerationLog.changeReason")}");

			if (reason == null || reason == "") {
				alert("${I18n.getMessage("ModerationLog.reasonIsEmpty")}");
				return false;
			}
			else {
				var link = document.getElementById("delete" + postId);
				link.href += "&log_description=" + encodeURIComponent(reason) + "&log_type=1";
			}

			return true;
		}
		
		return false;
	}
</#if>

-->
</script>

<#if Request.forumdata.moderator>
	<script type="text/JavaScript" src="${Request.forumdata.JForumContext.encodeURL("/js/list/moderation")}"></script>
</#if>

<table cellspacing="0" cellpadding="10" width="100%" align="center" border="0">
	<tr>
		<td class="bodyline">
			<table cellspacing="2" cellpadding="2" width="100%" border="0">
				<tr>
					<td valign="middle" align="left" colspan="2">
						<span class="maintitle"><a href="${Request.forumdata.JForumContext.encodeURL("/posts/list/${Request.forumdata.topic.id}")}" name="top" class="maintitle" id="top">${Request.forumdata.topic.title?html}</a></span>
						<#if Request.forumdata.rssEnabled>
						&nbsp;<a href="${Request.forumdata.contextPath}/rss/topicPosts/${Request.forumdata.topic.id}${Request.forumdata.extension}"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/xml_button.gif" border="0" alt="XML" /></a>
						</#if>
					</td>
				</tr>
			</table>
			
			<table cellspacing="2" cellpadding="2" width="100%" border="0">
				<tr>
					<#if !Request.forumdata.readonly>
					<td width="8%" align="left" valign="bottom" nowrap="nowrap">
					</#if>
						<#if Request.forumdata.topic.status == Request.forumdata.STATUS_LOCKED>
							<span class="icon_reply_locked"><img src="${Request.forumdata.contextPath}/images/transp.gif" alt="" /></span>
						<#else>
							<#if !Request.forumdata.readonly>
								<a href="${Request.forumdata.JForumContext.encodeURL("/posts/reply/${Request.forumdata.start}/${Request.forumdata.topic.id}")}" rel="nofollow" class="icon_reply nav"><img src="${Request.forumdata.contextPath}/images/transp.gif" alt="" /></a>
							<#else>
								<#assign colspan = "2"/>
							</#if>
						</#if>
					</td>

					<td valign="middle" align="left" colspan="${Request.forumdata.colspan?default("0")}">
						<span class="nav">
						<a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/list")}">${Request.forumdata.I18n.getMessage("ForumListing.forumIndex")} </a> 
            			&raquo; <a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/show.action?fid=${Request.forumdata.forum.id}")}">${Request.forumdata.forum.name} </a></span>
					</td>
					<td valign="middle" align="right"><#assign paginationData><@pagination.doPagination "list", Request.forumdata.topic.id/></#assign>${paginationData}</td>
				</tr>
			</table>

			<table class="forumline" cellspacing="1" cellpadding="3" width="100%" border="0">
				<#if poll?exists>
					<tr>
						<td class="cathead cattitle" align="center" colspan="2" nowrap="nowrap" width="100%">${Request.forumdata.I18n.getMessage("PostShow.pollTitle")}</td>
					</tr>
					<tr>
						<td class="row1" colspan="2" align="center">
							<#if (poll.open && canVoteOnPoll && !request.getParameter("viewResults")?exists)>
								<form action="${Request.forumdata.JForumContext.encodeURL("/jforum")}" method="post">
									<input type="hidden" name="action" value="vote" />
									<input type="hidden" name="module" value="${Request.forumdata.moduleName}" />
									<input type="hidden" name="poll_id" value="${Request.forumdata.poll.id}" />
									<input type="hidden" name="topic_id" value="${Request.forumdata.topic.id}" />
									<div class="poll">
										<span class="strong">${Request.forumdata.poll.label?html}</span>
										<table class="poll">
										<#list poll.options as option>
											<tr>
												<td><input type="radio" name="poll_option" value="${Request.forumdata.option.id}">${Request.forumdata.option.text?html}</input></td>
											</tr>
										</#list>
										</table>
										<input type="submit" value="${Request.forumdata.I18n.getMessage("PostShow.pollVote")}"></input><br />
										<span class="gensmall" align="center"><a href="${Request.forumdata.JForumContext.encodeURL("/jforum${Request.forumdata.extension}?module=posts&amp;action=list&amp;topic_id=${Request.forumdata.topic.id}&amp;viewResults=true", "")}">${Request.forumdata.I18n.getMessage("PostShow.showPollResults")}</a></span>
									</div>
								</form>
							<#else>
								<@presentation.renderPoll poll/>
							</#if>
						</td>
					</tr>
				</#if>
				
				<tr>
					<th class="thleft" nowrap="nowrap" width="150" height="26">${Request.forumdata.I18n.getMessage("PostShow.author")}</th>
					<th class="thright" nowrap="nowrap" width="100%">${Request.forumdata.I18n.getMessage("PostShow.messageTitle")}</th>
				</tr>

				<!-- POST LISTING --> 
				<#assign rowColor = ""/>
				<#list Request.forumdata.posts as post>
					<#if post_index % 2 == 0>
						<#assign rowColor = "row1">
					<#else>
						<#assign rowColor = "row2">
					</#if>
	
					<#assign user = Request.forumdata.users.get(post.userId)/>
					<#assign canEditCurrentMessage = (post.canEdit && Request.forumdata.topic.status != Request.forumdata.STATUS_LOCKED) || Request.forumdata.moderatorCanEdit/>
					<tr>
						<td colspan="2">
							<#include "post_show_action_buttons_inc.htm"/>
						</td>
					</tr>

					<tr>
						<!-- Username -->
						<#assign rowspan = "3"/>
						<#assign useSignature = (user.attachSignatureEnabled && user.signature?exists && user.signature?length > 0 && post.isSignatureEnabled())/>

						<#if useSignature>
							<#assign rowspan = "3"/>
						<#else>
							<#assign rowspan = "2"/>
						</#if>

						<td class="${rowColor}" valign="top" align="left" rowspan="${rowspan}">
							<#include "post_show_user_inc.htm"/>
						</td>
		
						<!-- Message -->
						<td class="${rowColor}" valign="top" id="post_text_${post.id}">
							<span class="postbody">
								<#if canEditCurrentMessage>
									<#assign canEditSomeMessage = true/>
									<div class="edit_area" id="${post.id}">${post.text}</div>
								<#else>
									${post.text}
								</#if>
							</span>

							<!-- Attachments -->
							<#if post.hasAttachments() && (canDownloadAttachments || attachmentsEnabled)>
								<#assign attachments = am.getAttachments(post.id, post.forumId)/>

								<#include "post_show_attachments_inc.htm"/>
							</#if>

							<#if (post.editCount > 0) && post.editTime?exists>
								<#if post.editCount == 1>
									<#assign editCountMessage = "PostShow.editCountSingle"/>
								<#else>
									<#assign editCountMessage = "PostShow.editCountMany"/>
								</#if>
								
								<p><i><span class="gensmall">${Request.forumdata.I18n.getMessage(editCountMessage, [post.editCount, post.editTime?datetime?string])}</span></i></p>
							</#if>
						</td>
					</tr>

					<#if useSignature>
						<tr>
							<td colspan="2" class="${rowColor}" width="100%" height="28"><hr/><span class="gensmall">${Request.forumdata.user.signature}</span></td>
						</tr>
					</#if>
		
					<tr> 
						<td class="${rowColor}" valign="bottom" nowrap="nowrap" height="28" width="100%">
							<#include "post_show_user_profile_inc.htm"/>					
						</td>
					</tr>
		
					<tr>
						<td class="spacerow" colspan="2" height="1"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/spacer.gif" alt="" width="1" height="1" /></td>
					</tr>
				</#list>
				<!-- END OF POST LISTING -->
		
				<tr align="center">
					<td class="catbottom" colspan="2" height="28">
						<table cellspacing="0" cellpadding="0" border="0">
							<tr>
								<td align="center"><span class="gensmall">&nbsp;</span></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		
			<table cellspacing="2" cellpadding="2" width="100%" align="center" border="0">
				<tr>
					<#if !Request.forumdata.readonly>
					<td width="8%" align="left" valign="bottom" nowrap="nowrap">
					</#if>
					<#if Request.forumdata.topic.status == Request.forumdata.STATUS_LOCKED>
						<span class="icon_reply_locked"><img src="${Request.forumdata.contextPath}/images/transp.gif" alt="" /></span>
					<#else>
						<#if !Request.forumdata.readonly>
							<a href="${Request.forumdata.JForumContext.encodeURL("/posts/reply/${Request.forumdata.start}/${Request.forumdata.topic.id}")}" rel="nofollow" class="icon_reply nav"><img src="${Request.forumdata.contextPath}/images/transp.gif" alt="" /></a>
						<#else>
							<#assign colspan = "2"/>
						</#if>
		  			</#if>
					</td>
					
					<td valign="middle" align="left" colspan="${Request.forumdata.colspan?default("0")}">
						<span class="nav">
						<a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/list")}">${Request.forumdata.I18n.getMessage("ForumListing.forumIndex")} </a> 
            			&raquo; <a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/show.action?fid=${Request.forumdata.forum.id}")}">${Request.forumdata.forum.name} </a>
						</span>
					</td>

					<td valign="middle" align="right">${paginationData}</td>
				</tr>
			</table>
			
			<table width="100%" align="center">
				
				<#if (Request.forumdata.logged || Request.forumdata.anonymousPosts) && Request.forumdata.topic.status != Request.forumdata.STATUS_LOCKED && !Request.forumdata.readonly>
					<tr>
						<td colspan="3">
					<script type="text/javascript">
					function newCaptcha()
					{
						document.getElementById("captcha_img").src = "${Request.forumdata.contextPath}/jforum${Request.forumdata.extension}?module=captcha&action=generate&timestamp=" + new Date().getTime();
					}
					
					function activateQuickReply()
					{
						$("#captcha_img").attr("src", "${Request.forumdata.JForumContext.encodeURL("/captcha/generate/${Request.forumdata.timestamp}")}");
						$("#quickReply").slideToggle('slow', function() {
							window.scrollBy(0, 1000);
						});
					}

					function validatePostForm(f)
					{
						if (f.message.value.replace(/^\s*|\s*$/g, "").length == 0) {
							alert("${Request.forumdata.I18n.getMessage("PostForm.textEmpty")}");
							f.message.focus();
						
							return false;
						}
					
						$("#icon_saving").css("display", "inline");
						$("#btnSubmit").attr("disabled", "disabled").val("${Request.forumdata.I18n.getMessage("PostForm.saving")}...");
					
						return true;
					}
					-->
					</script>

					
					<form action="${Request.forumdata.JForumContext.encodeURL("/jforum")}" method="post" name="post" id="post" onsubmit="return validatePostForm(this);" enctype="multipart/form-data" accept-charset="${Request.forumdata.encoding}">
						<input type="hidden" name="action" value="insertSave" />
						<input type="hidden" name="module" value="posts" />
						<input type="hidden" name="forum_id" value="${Request.forumdata.forum.id}" />
						<input type="hidden" name="start" value="${Request.forumdata.start?default("")}" />
						<input type="hidden" name="topic_id" value="${Request.forumdata.topic.id}" />
						<input type="hidden" name="disable_html" value="1" />
						<input type="hidden" name="quick" value="1" />
	
						<table width="100%">
							<tr>
								<td align="center">
									<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_mini_message.gif" align="middle" alt="Message" />
									<span class="nav"><a href="javascript:activateQuickReply()">${Request.forumdata.I18n.getMessage("PostForm.quickReply")}</a></span>
								</td>
							</tr>
						</table>
						
						<p align="center" style="display: none;" id="quickReply">
							<table>
								<tr>
									<td align="center">
										<textarea class="post" style="width: 350px" name="message" rows="10" cols="35" onkeyup="enterText(this);" onclick="enterText(this);" onselect="enterText(this);" onblur="leaveText();"></textarea>
									</td>
								</tr>
								<#if needCaptcha?default(false)>
									<tr>
										<td>
											<img border="0" align="middle" id="captcha_img"/>
											<br />
											<span class="gensmall">${Request.forumdata.I18n.getMessage("User.captchaResponse")}</span>
											<input type="text" class="post" style="width: 80px; font-weight: bold;" maxlength="25" name="captcha_anwser" /> 
											<br />
											<span class="gensmall">${Request.forumdata.I18n.getMessage("User.hardCaptchaPart1")} <a href="#newCaptcha" onClick="newCaptcha()"><b>${Request.forumdata.I18n.getMessage("User.hardCaptchaPart2")}</b></a></span>
										</td>
									</tr>
								</#if>
								<tr>
									<td align="right" valign="center">
										<input type="submit" id="btnSubmit" value="${Request.forumdata.I18n.getMessage("PostForm.submit")}" class="mainoption" />
										<img src="${Request.forumdata.contextPath}/images/transp.gif" id="icon_saving">
									</td>
								</tr>
							</table>
						</p>
					</form>
					</p>

						</td>
					</tr>
				</#if>
				
				<#if Request.forumdata.isModerator || Request.forumdata.isAdmin>
					<form action="${Request.forumdata.JForumContext.encodeURL("/jforum")}" method="post" name="formModeration" id="formModeration">
					<input type="hidden" name="action" value="doModeration" />
					<input type="hidden" name="module" value="moderation" />
					<input type="hidden" name="returnUrl" value="${Request.forumdata.JForumContext.encodeURL("/${Request.forumdata.moduleName}/${Request.forumdata.action}/${Request.forumdata.start}/${Request.forumdata.topic.id}")}" />
					<input type="hidden" name="forum_id" value="${Request.forumdata.topic.forumId}" />
					<input type="hidden" name="topic_id" value="${Request.forumdata.topic.id}" />
					<input type="hidden" name="log_type" value="0"/>
					<input type="hidden" name="log_description">
					<input type="hidden" id="moderationTodo" />

					<tr>
						<td align="left" colspan="3">
							<@presentation.moderationImages/>
						</td>
					</tr>
					</form>
				</#if>
			</table>

			<table cellspacing="0" cellpadding="0" width="100%" border="0">
				<tr>
					<td align="left" valign="top" class="gensmall">
						<#if logged>
							<#if bookmarksEnabled>
								<a href="javascript:addBookmark(2, ${Request.forumdata.topic.id});"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_bookmark.gif" align="middle"  alt="XML" />&nbsp;${Request.forumdata.I18n.getMessage("Bookmarks.addTo")}</a>
								<br>
							</#if>
						
							<#if !watching>
								<#assign watchMessage = I18n.getMessage("PostShow.watch")/>
								<a href="#watch" onClick="watchTopic('${Request.forumdata.JForumContext.encodeURL("/posts/watch/${Request.forumdata.start}/${Request.forumdata.topic.id}")}', '${Request.forumdata.I18n.getMessage("PostShow.confirmWatch")}');">
							<#else>
								<#assign watchMessage = I18n.getMessage("PostShow.unwatch")/>
								<a href="${Request.forumdata.JForumContext.encodeURL("/posts/unwatch/${Request.forumdata.start}/${Request.forumdata.topic.id}")}">
							</#if>
							<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/watch.gif" align="middle" alt="Watch" />&nbsp;${Request.forumdata.watchMessage}</a>
						</#if>
					</td>
					<td align="right"><@presentation.forumsComboTable/></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<a name="quick"></a>

<script type="text/javascript">
$(document).ready(function() {
	limitURLSize();

	<#if Request.forumdata.moderatorCanEdit || canEditSomeMessage>
		$(".edit_area").editable("${Request.forumdata.contextPath}/jforum${Request.forumdata.extension}?module=ajax&action=savePost", {
			submit: '${Request.forumdata.I18n.getMessage("Update")}',
			cancel: '${Request.forumdata.I18n.getMessage("cancel")}',
			type: 'textarea',
			tooltip: '${Request.forumdata.I18n.getMessage("PostShow.doubleClickEdit")}',
			rows: 15,
			width: '100%',
			event: 'dblclick',
			indicator: "<img src='${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/indicator.gif'>",
			postload: '${Request.forumdata.contextPath}/jforum${Request.forumdata.extension}?module=ajax&action=loadPostContents',
			cssclass: 'inlineedit',
			loadtext: '${Request.forumdata.I18n.getMessage("PostShow.loading")}...',
			beforesubmit: function(submitdata) { 
				<#if moderationLoggingEnabled>
					var message = prompt("${Request.forumdata.I18n.getMessage("ModerationLog.changeReason")}");

					if (message == null || message == "") {
						alert("${Request.forumdata.I18n.getMessage("ModerationLog.reasonIsEmpty")}");
						return false;
					}
					else {
						submitdata["log_description"] = message;
						submitdata["log_type"] = 2;
					}
				</#if>

				return true;
			}
		}, function(s) {
			<#if hasCodeBlock>
				dp.sh.HighlightAll('code');
			<#else>
				if (s.indexOf("name=\"code\"") > -1) {
					document.location.reload(true);
				}
			</#if>
		});
	</#if>
});
</script>

<#include "bottom.htm"/>