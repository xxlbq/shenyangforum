<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<tr>
		<td colspan="2" id="tdAttachPanel" align="center">
			<input type="hidden" name="edit_attach_ids" />
			<input type="hidden" name="delete_attach" />
			<input type="hidden" name="total_files" id="total_files" />

			<table border="0" cellpadding="3" cellspacing="0" width="100%" id="tblAttachments">
				<tr>
					<td>
						<span class="gensmall">
						<b>${Request.forumdata.I18n.getMessage("Attachments.maxToAttach")}:</b> ${maxAttachments}
						<#assign maxSize = maxAttachmentsSize / 1024>
						<#if (maxSize > 1)>
							/ 
							<b>${Request.forumdata.I18n.getMessage("Attachments.maxSize")}:</b> <font color="red">${maxSize} kb</font>
						</#if>
						</span>
					</td>
				</tr>
				<tr>
					<td align="center">
						<div id="edit_attach"></div>

						<div id="attachmentFields">
						</div>			   
					</td>
				</tr>
				<#if attachmentsEnabled>
					<tr>
						<td align="center" class="row3"><input type="button" name="add_attach" value="${Request.forumdata.I18n.getMessage("PostForm.AddAnotherFile")}" class="mainoption" onclick="addAttachmentFields()" /></td>
					</tr>

					<#if !attachments?exists>
						<script type="text/javascript">addAttachmentFields();</script>
					</#if>
									
				</#if>
			</table>
		</td>
	</tr>
</table>