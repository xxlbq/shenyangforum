<#include "header.ftl"/>
<#assign preview = Request.forumdata.preview?default(false)/>
<#assign logModeration = Request.forumdata.moderationLoggingEnabled && Request.forumdata.isEdit?default(false) && Request.forumdata.isModerator && user.id != post.userId/>
<#assign allowPoll = Request.forumdata.setType?default(true) && Request.forumdata.canCreatePolls?default(false)/>

<script type="text/javascript">
var CONTEXTPATH = "${Request.forumdata.contextPath}";
var SERVLET_EXTENSION  = "${Request.forumdata.extension}";
</script>

<style type="text/css">@import url( ${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/styles/tabs.css?${Application.startupTime} );</style>
<style type="text/css">@import url( ${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/styles/SyntaxHighlighter.css?${Application.startupTime} );</style>

<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/jquery.js?${Application.startupTime}"></script>
<script type="text/javascript" src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/js/post.js?${Application.startupTime}"></script>

<script type="text/javascript">
<#include "js/bbcode_help.js"/>
<#include "js/utils.js"/>
<#include "js/attachments.js"/>
</script>

<script type="text/javascript">
<!--
function newCaptcha()
{
	document.getElementById("captcha_img").src = "${Request.forumdata.contextPath}/jforum${Request.forumdata.extension}?module=captcha&action=generate&timestamp=" + new Date().getTime();
}

function validatePostForm(f)
{
	<#if setType?default(true)>
	if (f.subject.value == "") {
		alert("${Request.forumdata.I18n.getMessage("PostForm.subjectEmpty")}");
		f.subject.focus();
		
		return false;
	}
	</#if>
	
	if (f.message.value.replace(/^\s*|\s*$/g, "").length == 0) {
		alert("${Request.forumdata.I18n.getMessage("PostForm.textEmpty")}");
		f.message.focus();
		
		return false;
	}

	<#if !forum?exists>
	if (f.toUsername.value == "") {
		alert("${Request.forumdata.I18n.getMessage("PrivateMessage.toUserIsEmpy")}");
		f.toUsername.focus();

		return false;
	}
	</#if>

	<#if logModeration>
	if (f.log_description.value == "") {
		alert("${Request.forumdata.I18n.getMessage("ModerationLog.reasonIsEmpty")}");
		f.log_description.focus();

		return false;
	}
	</#if>
	
	$("#icon_saving").css("display", "inline");
	$("#btnPreview").attr("disabled", "disabled");
	$("#btnSubmit").attr("disabled", "disabled").val("${Request.forumdata.I18n.getMessage("PostForm.saving")}...");
	
	return true;
}

function openFindUserWindow()
{
	var w = window.open("${Request.forumdata.JForumContext.encodeURL("/pm/findUser")}", "_findUser", "height=250,resizable=yes,width=400");
	w.focus();
}

function smiliePopup()
{
	var w = window.open("${Request.forumdata.JForumContext.encodeURL("/posts/listSmilies")}", "smilies", "width=300, height=300, toolbars=no, scrollbars=yes");
	w.focus();
}

-->
</script>

<#assign preview = Request.forumdata.preview?exists && Request.forumdata.preview/>
<#assign isNewPost = Request.forumdata.isNewPost?exists && Request.forumdata.isNewPost/>
<#assign isEdit = Request.forumdata.isEdit?if_exists/>
<#assign isNewTopic = (!topic?exists || topic.id == -1)/>
<#assign attachmentsEnabled = Request.forumdata.attachmentsEnabled?exists && Request.forumdata.attachmentsEnabled/>

<#if !Request.forumdata.maxAttachments?exists>
	<#assign maxAttachments = 0/>
</#if>

<#assign htmlChecked = "checked=\"checked\""/>
<#assign bbChecked = ""/>
<#assign signatureChecked = "checked=\"checked\""/>
<#assign repliesChecked = "checked=\"checked\""/>
<#assign smiliesChecked = ""/>

<#if isNewPost && !preview && !post?exists>
	<#if Request.forumdata.user.isHtmlEnabled()><#assign htmlChecked = ""/></#if>
	<#if !Request.forumdata.user.isBbCodeEnabled()><#assign bbChecked = "checked=\"checked\""/></#if>
	<#if !Request.forumdata.user.isSmiliesEnabled()><#assign smiliesChecked = "checked=\"checked\""/></#if>
	<#if !Request.forumdata.user.getAttachSignatureEnabled()><#assign signatureChecked = ""/></#if>
<#elseif post?exists>
	<#if post.isHtmlEnabled()><#assign htmlChecked = ""/></#if>
	<#if !post.isBbCodeEnabled()><#assign bbChecked = "checked=\"checked\""/></#if>
	<#if !post.isSmiliesEnabled()><#assign smiliesChecked = "checked=\"checked\""/></#if>
	<#if !post.isSignatureEnabled()><#assign signatureChecked = ""/></#if>
</#if>

<#if !Request.forumdata.user.isNotifyOnMessagesEnabled()><#assign repliesChecked = ""/></#if>

<form action="${Request.forumdata.JForumContext.encodeURL("/jforum")}" method="post" enctype="multipart/form-data" name="post" id="post" onsubmit="return validatePostForm(this)">

<input type="hidden" name="preview" value="0"/>
<#if Request.forumdata.forum?exists><input type="hidden" name="forum_id" value="${Request.forumdata.forum.id}" /></#if>
<input type="hidden" name="start" value="${Request.forumdata.start?default("")}" />
<#if isEdit><input type="hidden" name="post_id" value="${post.id}" /></#if>
<#if !isNewTopic><input type="hidden" name="topic_id" value="${topic.id}" /></#if>

<table cellspacing="0" cellpadding="10" width="100%" align="center" border="0">
	<tr>
		<td class="bodyline">
			
			<!-- Preview message -->
			<a name="preview"></a>
			<table class="forumline" width="100%" cellspacing="1" cellpadding="4" border="0" <#if !preview>style="display: none"</#if> id="previewTable">
				<tr>
					<th height="25" class="thhead">${Request.forumdata.I18n.getMessage("PostForm.preview")}</th>
				</tr>
				<tr>
					<td class="row1">
						<img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/icon_minipost.gif" alt="Post" />
						<span class="postdetails" id="previewSubject"> ${Request.forumdata.I18n.getMessage("PostForm.subject")}: <#if Request.forumdata.postPreview?exists>${Request.forumdata.postPreview.subject?html}</#if></span>
					</td>
				</tr>
				<tr>
					<td class="row1" height="100%">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" style="height:100%">
							<tr>
								<td><span id="previewMessage" class="postbody"><#if Request.forumdata.postPreview?exists>${Request.forumdata.postPreview.text}</#if></span></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class="spacerow" height="1"><img src="${Request.forumdata.contextPath}/templates/${Request.forumdata.templateName}/images/spacer.gif" alt="" width="1" height="1" /></td>
				</tr>
			</table>
			<br clear="all" />

			<table cellspacing="2" cellpadding="2" width="100%" align="center" border="0">
				<tr>
					<td align="left">
						<span class="nav">
							<a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/list")}">${Request.forumdata.I18n.getMessage("ForumListing.forumIndex")}</a>

							<#if Request.forumdata.forum?exists>
							&raquo; <a class="nav" href="${Request.forumdata.JForumContext.encodeURL("/forums/show/${Request.forumdata.forum.id}")}">${Request.forumdata.forum.name}</a>
							</#if>
						</span>
					</td>
				</tr>
			</table>
		
			<table class="forumline" cellspacing="1" cellpadding="3" width="100%" border="0">
				<tr>
					<th class="thhead" colspan="2" height="25">
						<b>
						<#if Request.forumdata.forum?exists>
							<#if (topic?exists && topic.id > -1)>
							    <#if isEdit>
							    	${Request.forumdata.I18n.getMessage("PostForm.edit")} "${topic.title?html}"
							    <#else>
									${Request.forumdata.I18n.getMessage("PostForm.reply")} "${topic.title?html}"
								</#if>
							<#else>
								${Request.forumdata.I18n.getMessage("PostForm.title")}
							</#if>
						<#else>
							<#if pmReply?default(false)>
								${Request.forumdata.I18n.getMessage("PrivateMessage.reply")}
							<#else>
								${Request.forumdata.I18n.getMessage("PrivateMessage.title")}
							</#if>
						</#if>
						</b>
					</th>
				</tr>

				<#if !Request.forumdata.forum?exists>
					<tr>
						<td class="row1" width="15%"><span class="gen"><b>${Request.forumdata.I18n.getMessage("PrivateMessage.user")}</b></span></td>
						<td class="row2" width="85%">
							<#if pmRecipient?exists>
								<#assign toUsername = toUsername/>
								<#assign toUserId = toUserId/>
								<#elseif preview>
								<#assign toUsername = pm.toUser.username/>
								<#assign toUserId = pm.toUser.id/>
								<#elseif quote?default("") == "true" || pmReply?default(false)>
								<#assign toUsername = pm.fromUser.username/>
								<#assign toUserId = pm.fromUser.id/>
							<#else>
								<#assign toUsername = ""/>
								<#assign toUserId = ""/>
							</#if>

							<input type="text" class="post" size="25" name="toUsername" value="${toUsername}"/>&nbsp;
							<input type="button" value="${Request.forumdata.I18n.getMessage("PrivateMessage.findUser")}" name="findUser" class="liteoption" onclick="openFindUserWindow(); return false;" />
							<input type="hidden" name="toUserId" value="${toUserId}" />
						</td>
					</tr>
				</#if>

				<#if Request.forumdata.errorMessage?exists>
					<tr>
						<td colspan="2" align="center"><span class="gen"><font color="#ff0000"><b>${Request.forumdata.errorMessage}</b></font></span></td>
					</tr>
				</#if>

				<tr>
					<td class="row1" width="15%"><span class="gen"><b>${Request.forumdata.I18n.getMessage("PostForm.subject")}</b></span></td>
					<#if post?exists>
						<#assign subject = post.subject?default("")?html/>
						<#elseif pmReply?default(false)>
						<#assign subject = pm.post.subject?html/>
						<#elseif topic?exists>
						<#assign subject = I18n.getMessage("Message.replyPrefix") + topic.title?default("")?html/>
					</#if>
					<td class="row2" width="85%">
						<span class="gen">
							<input class="subject" type="text" tabindex="2" maxlength="100" name="subject" value="${subject?default("")}" /> 
						</span>
					</td>
				</tr>

				<tr>
					<!-- Smilies -->
					<td class="row1" valign="top">
						<span class="gen"><b>${Request.forumdata.I18n.getMessage("PostForm.body")}</b></span>

						<table cellspacing="0" cellpadding="1" border="0" align="center">
							<tr>
								<td valign="middle" align="center">
									<br />
									<table cellspacing="0" cellpadding="5" width="100" border="0">
										<tr align="center">
											<td class="gensmall" colspan="4"><b>${Request.forumdata.I18n.getMessage("PostForm.emoticons")}</b></td>
										</tr>

										<#assign count = 0/>
										<#assign lastSmilie = ""/>
											<#list Request.forumdata.smilies as smilie>
												<#if (count < 20)>
													<#if lastSmilie == "" || lastSmilie.url != smilie.url>
														<#if count % 4 == 0>
															<tr>
														</#if>
														<td><a href="javascript:emoticon('${smilie.code}');">${smilie.url}</a></td>
														<#assign count = count + 1/>
														<#if count % 4 == 0>
															</tr>
														</#if>
														<#assign lastSmilie = smilie/>
													</#if>
												</#if>
											</#list>

											<#if !(count % 4 == 0)>
											</#if>
										<tr align="center">
											<td colspan="4">
												<span class="nav"><a href="#" onclick="smiliePopup();return false;">${Request.forumdata.I18n.getMessage("PostForm.moreSmilies")}</a></span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>

					<!-- BB Codes, textarea -->
					<td class="row2" valign="top">
						<div class="gen">
							<table cellspacing="0" cellpadding="2" border="0" width="100%">
								<!-- bb code -->
								<tr valign="middle">
									<td>
										<input class="button" onmouseover="helpline('b')" style="FONT-WEIGHT: bold; WIDTH: 30px" accesskey="b" onclick="bbstyle(0)" type="button" value=" B " name="addbbcode0" /> 
										<input class="button" onmouseover="helpline('i')" style="WIDTH: 30px; FONT-STYLE: italic" accesskey="i" onclick="bbstyle(2)" type="button" value=" i " name="addbbcode2" /> 
										<input class="button" onmouseover="helpline('u')" style="WIDTH: 30px; TEXT-DECORATION: underline" accesskey="u" onclick="bbstyle(4)" type="button" value=" u " name="addbbcode4" />
										<input class="button" onmouseover="helpline('q')" style="WIDTH: 50px" accesskey="q" onclick="bbstyle(6)" type="button" value="Quote" name="addbbcode6" /> 
										<input class="button" onmouseover="helpline('c')" style="WIDTH: 40px" accesskey="c" onclick="bbstyle(8)" type="button" value="Code" name="addbbcode8" />
										<input class="button" onmouseover="helpline('l')" style="WIDTH: 40px" accesskey="l" onclick="bbstyle(10)" type="button" value="List" name="addbbcode10" />
										<input class="button" onmouseover="helpline('p')" style="WIDTH: 40px" accesskey="p" onclick="bbstyle(12)" type="button" value="Img" name="addbbcode12" />
										<input class="button" onmouseover="helpline('w')" style="WIDTH: 40px" accesskey="w" onclick="bbstyle(14)" type="button" value="URL" name="addbbcode14" />
										<input class="button" onmouseover="helpline('g')" style="WIDTH: 50px" accesskey="g" onclick="bbstyle(16)" type="button" value="Google" name="addbbcode16" />
										<input class="button" onmouseover="helpline('y')" style="WIDTH: 60px" accesskey="y" onclick="bbstyle(18)" type="button" value="Youtube" name="addbbcode18" />
										<input class="button" onmouseover="helpline('k')" style="WIDTH: 40px" accesskey="k" onclick="bbstyle(20)" type="button" value="Flash" name="addbbcode20" />
										<input class="button" onmouseover="helpline('v')" style="WIDTH: 40px" accesskey="v" onclick="bbstyle(22)" type="button" value="WMV" name="addbbcode22" />
									</td>
								</tr>
								
								<!-- Color, Fonts -->
								<tr>
									<td>
										<span class="genmed">&nbsp;${Request.forumdata.I18n.getMessage("PostForm.textColor")}: 
										<select onmouseover="helpline('s')" onchange="bbfontstyle('[color=' + this.form.addbbcode24.options[this.form.addbbcode24.selectedIndex].value + ']', '[/color]')" name="addbbcode24"> 
											<option class="genmed" style="COLOR: black; BACKGROUND-COLOR: #fafafa" value="#444444" selected="selected">${Request.forumdata.I18n.getMessage("PostForm.colorDefault")}</option> 
											<option class="genmed" style="COLOR: darkred; BACKGROUND-COLOR: #fafafa" value="darkred">${Request.forumdata.I18n.getMessage("PostForm.colorDarkRed")}</option> 
											<option class="genmed" style="COLOR: red; BACKGROUND-COLOR: #fafafa" value="red">${Request.forumdata.I18n.getMessage("PostForm.colorRed")}</option> 
											<option class="genmed" style="COLOR: orange; BACKGROUND-COLOR: #fafafa" value="orange">${Request.forumdata.I18n.getMessage("PostForm.colorOrange")}</option> 
											<option class="genmed" style="COLOR: brown; BACKGROUND-COLOR: #fafafa" value="brown">${Request.forumdata.I18n.getMessage("PostForm.colorBrown")}</option> 
											<option class="genmed" style="COLOR: yellow; BACKGROUND-COLOR: #fafafa" value="yellow">${Request.forumdata.I18n.getMessage("PostForm.colorYellow")}</option> 
											<option class="genmed" style="COLOR: green; BACKGROUND-COLOR: #fafafa" value="green">${Request.forumdata.I18n.getMessage("PostForm.colorGreen")}</option> 
											<option class="genmed" style="COLOR: olive; BACKGROUND-COLOR: #fafafa" value="olive">${Request.forumdata.I18n.getMessage("PostForm.colorOlive")}</option> 
											<option class="genmed" style="COLOR: cyan; BACKGROUND-COLOR: #fafafa" value="cyan">${Request.forumdata.I18n.getMessage("PostForm.colorCyan")}</option> 
											<option class="genmed" style="COLOR: blue; BACKGROUND-COLOR: #fafafa" value="blue">${Request.forumdata.I18n.getMessage("PostForm.colorBlue")}</option> 
											<option class="genmed" style="COLOR: darkblue; BACKGROUND-COLOR: #fafafa" value="darkblue">${Request.forumdata.I18n.getMessage("PostForm.colorDarkBlue")}</option> 
											<option class="genmed" style="COLOR: violet; BACKGROUND-COLOR: #fafafa" value="violet">${Request.forumdata.I18n.getMessage("PostForm.colorViolet")}</option> 
											<option class="genmed" style="COLOR: white; BACKGROUND-COLOR: #fafafa" value="white">${Request.forumdata.I18n.getMessage("PostForm.colorWhite")}</option>
											<option class="genmed" style="COLOR: black; BACKGROUND-COLOR: #fafafa" value="black">${Request.forumdata.I18n.getMessage("PostForm.colorBlack")}</option>
										</select> 

										&nbsp;${Request.forumdata.I18n.getMessage("PostForm.font")}:
										<select onmouseover="helpline('f')" onchange="bbfontstyle('[size=' + this.form.addbbcode26.options[this.form.addbbcode26.selectedIndex].value + ']', '[/size]')" name="addbbcode26"> 
											<option class="genmed" value="7">${Request.forumdata.I18n.getMessage("PostForm.fontVerySmall")}</option> 
											<option class="genmed" value="9">${Request.forumdata.I18n.getMessage("PostForm.fontSmall")}</option> 
											<option class="genmed" value="12" selected="selected">${Request.forumdata.I18n.getMessage("PostForm.fontNormal")}</option> 
											<option class="genmed" value="18">${Request.forumdata.I18n.getMessage("PostForm.fontBig")}</option> 
											<option class="genmed" value="24">${Request.forumdata.I18n.getMessage("PostForm.fontGiant")}</option>
										</select> 
										</span>
										<span class="gensmall"><a class="genmed" onmouseover="helpline('a')" href="javascript:bbstyle(-1)">${Request.forumdata.I18n.getMessage("PostForm.closeMarks")}</a></span>
									</td>
								</tr>

								<!-- Help box -->
								<tr>
									<td>
										<input name="helpbox" class="helpline" readonly="readonly" style="FONT-SIZE: 10px; WIDTH: 100%" value="${Request.forumdata.I18n.getMessage("PostForm.helplineTip")}" size="45" maxlength="100" /> 
									</td>
								</tr>
								
								<!-- Textarea -->
								<tr>
									<td valign="top">
										<textarea class="message" onkeyup="storeCaret(this);" onclick="storeCaret(this);" onselect="storeCaret(this);" tabindex="3" name="message" rows="15"  cols="35"><#if post?exists><#if quote?exists>[quote=${quoteUser}]${post.text?html}[/quote]<#else>${post.text?html}</#if></#if></textarea> 
									</td>
								</tr>
							</table>
						</div> 
					</td>
				</tr>

				<!-- Options -->
				<tr>
					<td class="row1">&nbsp;</td>
					<td class="row2">
						<div id="tabs10">
							<ul>
							    <li target="postOptions" class="current"><a href="javascript:void(0);" onClick="activateTab('postOptions', this);"><span>Options</span></a></li>

								<#if allowPoll>
									<li target="postPoll"><a href="javascript:void(0);" onClick="activateTab('postPoll', this);"><span>Poll</span></a></li>
								</#if>
								<#if attachmentsEnabled>
								    <li target="postAttachments"><a href="javascript:void(0);" onClick="activateTab('postAttachments', this);"><span>Attachments</span></a></li>
								</#if>
							</ul>
						</div>

						<!-- Post Options -->
						<div id="postOptions" class="postTabContents">
							<div>
								<#include "post_options_tab.ftl"/>
							</div>
						</div>

						<!-- Poll tab -->
						<#if allowPoll>
							<div id="postPoll" class="postTabContents" style="display: none;">
								<div>
									<#include "post_poll_tab.ftl"/>
								</div>
							</div>
						</#if>

						<!-- Attachments tab -->
						<#if attachmentsEnabled || attachments?exists>
							<div id="postAttachments" class="postTabContents" style="display: none; ">
								<div>
									<#include "post_attachments_tab.ftl"/>
								</div>
							</div>
						</#if>
					</td>
				</tr

				<#if Request.forumdata.needCaptcha?default(false)>
					<tr>
						<td class="row1" valign="middle"><span class="gensmall"><b>${Request.forumdata.I18n.getMessage("User.captchaResponse")}:</b></span></td>
						<td class="row2">
							<input type="text" class="post" style="width: 100px; font-weight: bold;" maxlength="25" size="25" name="captcha_anwser" /> 
							<img src="${Request.forumdata.JForumContext.encodeURL("/captcha/generate/${timestamp}")}" border="0" align="middle" id="captcha_img" alt="Captcha unavailable" />
							<br />
							<span class="gensmall">${Request.forumdata.I18n.getMessage("User.hardCaptchaPart1")} <a href="#newCaptcha" onClick="newCaptcha()"><b>${Request.forumdata.I18n.getMessage("User.hardCaptchaPart2")}</b></a></span>
						</td>
					</tr>
				</#if>

				<#if logModeration>
					<tr>
						<td align="center" class="row1 gen"><b>${Request.forumdata.I18n.getMessage("ModerationLog.moderationLog")}</b></td>
						<td class="row2 genmed">${Request.forumdata.I18n.getMessage("ModerationLog.changeReason")} <input type="text" name="log_description" size="50" /><input type="hidden" name="log_type" value="2" /></td>
					</tr>
				</#if>

				<#if error?exists>
					<tr>
						<td class="row1">&nbsp;</td>
						<td class="row2"><span class="gen"><font color="red"><b>${error}</b></font></span></td>
					</tr>
				</#if>
				
				<tr>
					<td align="center" height="28" colspan="2" class="catbottom">
						<input class="mainoption" id="btnPreview" tabindex="5" type="button" value="${Request.forumdata.I18n.getMessage("PostForm.preview")}" onclick="previewMessage();" />&nbsp;
						<input class="mainoption" id="btnSubmit" accesskey="s" tabindex="6" type="submit" value="${Request.forumdata.I18n.getMessage("PostForm.submit")}" name="post" />
						<img src="${Request.forumdata.contextPath}/images/transp.gif" id="icon_saving">
					</td>
				</tr>
			</table>
		</td>
	</tr>

	<#if ((topic?exists && topic.id > 0) || pmReply?default(false))>
	<tr>
	<td colspan="2">
		<table border="0" cellpadding="3" cellspacing="0" width="100%" class="forumline">
			<tr>
				<th class="cathead" height="28" align="center"><b><span class="cattitle">${Request.forumdata.I18n.getMessage("PostShow.topicReview")}</span></b></th>
			</tr>
	
			<tr>
				<td class="row1">
					<#if pmReply?default(false)>
						<iframe width="100%" height="300" frameborder="0" src="${Request.forumdata.JForumContext.encodeURL("/jforum${Request.forumdata.extension}?module=pm&amp;action=review&amp;id=${pm.id}", "")}" ></iframe>
					<#else>
						<iframe width="100%" height="300" frameborder="0" src="${Request.forumdata.JForumContext.encodeURL("/posts/review/${start}/${topic.id}")}" ></iframe>
					</#if>
				</td>
			</tr>
			
		</table>
	</td>
	</tr>
	</#if>
</table>

<script type="text/javascript">
<!--
<#if attachments?exists>
	ignoreStart = true;
	editAttachments();
</#if>

<#if preview>document.location = "#preview";</#if>
-->
</script>

</form>

<#include "highlighter_js.ftl"/>
<#include "bottom.ftl"/>