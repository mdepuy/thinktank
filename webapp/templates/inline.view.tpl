<div class="">
    <!--{if $header}<h1>{$header}</h1>{/if}-->
    <!--{if $description}<h4>{$description}</h4>{/if}-->
</div>
	{if ($display eq 'tweets-all' and not $all_tweets) or 
		($display eq 'tweets-mostreplies' and not $most_replied_to_tweets) or
		($display eq 'tweets-mostretweeted' and not $most_retweeted) or
		($display eq 'tweets-convo' and not $author_replies)}
		<h2 class="alert">&#9888; No tweets to display.</h2>
	{/if}
	
	{if $all_tweets and $display eq 'tweets-all'}
		{foreach from=$all_tweets key=tid item=t name=foo}
			{include file="_post.mine.tpl" t=$t}
		{/foreach}
	{/if}
	
	{if $most_replied_to_tweets}
		{foreach from=$most_replied_to_tweets key=tid item=t name=foo}
			{include file="_post.mine.tpl" t=$t}
		{/foreach}
	{/if}

	{if $most_retweeted}
		{foreach from=$most_retweeted key=tid item=t name=foo}
			{include file="_post.mine.tpl" t=$t}
		{/foreach}
	{/if}

	{if $author_replies}
		{foreach from=$author_replies key=tahrt item=r name=foo}
			{include file="_post.qa.tpl" t=$t}
		{/foreach}
	{/if}

	
	{if ($display eq 'mentions-all' and not $all_mentions) or 
		($display eq 'mentions-allreplies' and not $all_replies) or
		($display eq 'mentions-orphan' and not $orphan_replies) or 
		($display eq 'mentions-standalone' and not $standalone_replies)}
		<h2 class="info">&#9888; No mentions to display.</h2> 
	{/if}

	{if $orphan_replies}
		{foreach from=$orphan_replies key=tid item=t name=foo}
			{include file="_post.otherorphan.tpl" t=$t}
		{/foreach}
		</form>		
	{/if} 


	{if $all_mentions}
		{foreach from=$all_mentions key=tid item=t name=foo}
			{include file="_post.otherorphan.tpl" t=$t}
		{/foreach}
	{/if}

	{if $all_replies}
		{foreach from=$all_replies key=tid item=t name=foo}
			{include file="_post.other.tpl" t=$t}
		{/foreach}
	{/if}

	{if $standalone_replies}
		{foreach from=$standalone_replies key=tid item=t name=foo}
			{include file="_post.otherorphan.tpl" t=$t}

		{/foreach}
		
	{/if}	

	{if ($display eq 'followers-former' and not $people)or 
		($display eq 'friends-former' and not $people) }
		<h2 class="info">&#9888; Not found.</h2> 
	{/if}


	{if $people}
		{foreach from=$people key=fid item=f name=foo}
		  {include file="_user.tpl" t=$f}
		{/foreach}	
	{/if}

	{if ($display eq 'links-friends' and not $links) or 
		($display eq 'links-favorites' and not $links)}
		<h2 class="alert">&#9888; No tweets to display.</h2>
	{/if}		
	{if $links}
		{foreach from=$links key=lid item=l name=foo}
		  {include file="_link.tpl" t=$f}
		{/foreach}	
	{/if}
		
	<script type="text/javascript" src="{$cfg->site_root_path}cssjs/linkify.js"></script>
	<script type="text/javascript" src="{$cfg->site_root_path}cssjs/bitly.js"></script>	

<script type="text/javascript">
	{literal}
	$(function() {
		//begin reply assignment actions
		$(".button").click(function() {  
		// validate and process form here  
			var element = $(this);
			var Id = element.attr("id");
			
			var oid = Id;
			var pid = $("select#pid"+Id+" option:selected").val();
			var u = '{/literal}{$i->network_username|escape:'url'}{literal}';
			
			var t = 'inline.view.tpl';
			var ck = '{/literal}{$i->network_username|escape:'url'}-{$smarty.session.user}-{$display}{literal}';
			var dataString = 'u='+ u + '&pid=' + pid + '&oid[]=' + oid + '&t=' + t + '&ck=' + ck;  
			//alert (dataString);return false;  
			    $.ajax({  
			      type: "GET",  
			      url: "{/literal}{$cfg->site_root_path}{literal}post/mark-parent.php",  
			      data: dataString,  
			      success: function() {  
				$('#div'+Id).html("<div class='success' id='message"+Id+"'></div>");  
				$('#message'+Id).html("<p>Saved!</p>") 
			       .hide()  
			       .fadeIn(1500, function() {  
				 $('#message'+Id);  
			       });  
			    }  
			   });  
			   return false;  
		      });  
	});	

	{/literal}
</script>