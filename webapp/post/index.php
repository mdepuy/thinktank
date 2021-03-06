<?php
session_start();
if (!isset($_SESSION['user'])) { header("Location: /session/login.php"); }

// set up
chdir("..");
require_once('config.webapp.inc.php');
ini_set("include_path", ini_get("include_path").PATH_SEPARATOR.$INCLUDE_PATH);
require_once("init.php");

$pd = new PostDAO($db);


if ( isset($_REQUEST['t']) && is_numeric($_REQUEST['t']) && $pd->isPostInDB($_REQUEST['t']) ){
	$status_id = $_REQUEST['t'];
	$s = new SmartyThinkTank();

	if(!$s->is_cached('status.index.tpl', $status_id)) {
		$post = $pd->getPost($status_id);

		$u = new Utils();

        // BUG: THIS ISN'T GOING TO WORK WHEN LOOKING AT POSTS OF OTHER USERS BECAUSE THEY DON'T HAVE INSTANCES
		$id = new InstanceDAO($db);
		$i = $id->getByUsername($post->author_username);
		
    	if ( isset($i) ) {
			$s->assign('likely_orphans', $pd->getLikelyOrphansForParent($post->pub_date, $i->network_user_id,$post->author_username, 15) );
			$s->assign('all_tweets', $pd->getAllPosts($i->network_user_id, 15) );

		}
		
		$cfg = new Config($i->network_username, $i->network_user_id);


		// instantiate data access objects
		$ud = new UserDAO($db);


		$all_replies = $pd->getRepliesToPost($status_id);
		$all_replies_count = count($all_replies);
		$all_retweets = $pd->getRetweetsOfPost($status_id);
		$retweet_reach = $pd->getPostReachViaRetweets($status_id);
		$public_replies = $pd->getPublicRepliesToPost($status_id);
		$public_replies_count = count($public_replies);
		$private_replies_count = $all_replies_count - $public_replies_count;
		$post = $pd->getPost($status_id);


		$s->assign('post', $post);
		$s->assign('replies', $all_replies );
		$s->assign('retweets', $all_retweets );
		$s->assign('retweet_reach', $retweet_reach);
		$s->assign('public_reply_count', $public_replies_count );
		$s->assign('private_reply_count', $private_replies_count );
		$s->assign('reply_count', $all_replies_count );


		$s->assign('cfg', $cfg);
		$s->assign('instance', $i);
		$s->assign('i', $i);
		
	}
	# clean up
	$db->closeConnection($conn);

	$s->display('post.index.tpl', $status_id);
} else {
	echo 'This update is not in the system.<br /><a href="'. $cfg->site_root_path .'">back home</a>';
}
?>
