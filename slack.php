<?

error_reporting(E_ALL ^ E_NOTICE);


$channel = $argv[1];
$text = $argv[2];
$icon_emoji = $argv[3];
$username = $argv[4];


if (empty($argv[1])) {
    echo ("チャンネルが選択されていません \n");
    exit;
}

if (empty($argv[2])) {
    echo ("メッセージがありません \n");
    exit;
}

if (empty($argv[3])) {
    $icon_emoji = ':bee:';
}

if (empty($argv[4])) {
    $username = 'slackUser';
}

$slackUrl = 'https://slack.com/api/chat.postMessage';

$token = '************'; // トークンを入れる

$params = array(
            'token'      => $token,
            'channel'    => $channel,
            'username'   => $username,
            'icon_emoji' => $icon_emoji,
            'text'       => $text,
        );

        // POST
        $stream = array('http' => array(
            'method'  => 'POST',
            'content' => http_build_query($params),
        ));
        return file_get_contents($slackUrl, false, stream_context_create($stream));

?>

