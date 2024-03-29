<table cellspacing="0" cellpadding="1" border="0" class="genmed">
	<#if Request.forumdata.htmlAllowed>
		<tr>
		<td><input type="checkbox" id="disable_html" name="disable_html" ${htmlChecked} /></td>
		<td><label for="disable_html">${Request.forumdata.I18n.getMessage("PostForm.disableHtml")}</label></td>
		</tr>
	<#else>
		<input type="hidden" name="disable_html" value="1" />
	</#if>
	<tr>
		<td><input type="checkbox" id="disable_bbcode" name="disable_bbcode" ${bbChecked} /> </td>
		<td><label for="disable_bbcode">${Request.forumdata.I18n.getMessage("PostForm.disableBbCode")}</label></td>
	</tr>
	<tr>
		<td><input type="checkbox" id="disable_smilies" name="disable_smilies" ${smiliesChecked} /> </td>
		<td><label for="disable_smilies">${Request.forumdata.I18n.getMessage("PostForm.disableSmilies")}</label></td>
	</tr>

	<#if Request.forumdata.user.id != 1>
		<tr>
			<td><input type="checkbox" id="attach_sig" name="attach_sig" ${signatureChecked} /> </td>
			<td><label for="attach_sig">${Request.forumdata.I18n.getMessage("PostForm.appendSignature")}</label></td>
		</tr>

		<#if forum?exists>
		<tr>
			<td><input type="checkbox" id="notify" name="notify" ${repliesChecked} /> </td>
			<td><label for="notify">${Request.forumdata.I18n.getMessage("PostForm.notifyReplies")}</label></td>
		</tr>
		</#if>
	</#if>

	<#if setType?default(true) && forum?exists && canCreateStickyOrAnnouncementTopics?default(false)>
	<tr>
		<td colspan="2">
			${Request.forumdata.I18n.getMessage("PostForm.setTopicAs")}:
			<input type="radio" checked="checked" value="0" id="topic_type0" name="topic_type" <#if topic?exists && topic.type == 0>checked="checked"</#if> /><label for="topic_type0">${Request.forumdata.I18n.getMessage("PostForm.setTopicAsNormal")}</label>&nbsp;&nbsp;
			<input type="radio" value="1" id="topic_type1" name="topic_type" <#if topic?exists && topic.type == 1>checked="checked"</#if> /><label for="topic_type1">${Request.forumdata.I18n.getMessage("PostForm.setTopicAsSticky")}</label>&nbsp;&nbsp;
			<input type="radio" value="2" id="topic_type2" name="topic_type" <#if topic?exists && topic.type == 2>checked="checked"</#if> /><label for="topic_type2">${Request.forumdata.I18n.getMessage("PostForm.setTopicAsAnnounce")}</label>&nbsp;&nbsp;
		</td>
	</tr>
	<#elseif topic?exists>
		<input type="hidden" name="topic_type" value="${topic.type}" />
	</#if>
</table>