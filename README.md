Stats Sample
===========

* Author:: Yuichi Takeuchi <uzuki05@takeyu-web.com>
* Website:: http://takeyu-web.com/
* Copyright:: Copyright 2013 Yuichi Takeuchi
* License:: MIT License

MovableType 6.0 のプラグインによる SiteStats 拡張のサンプルです。

このように、日付をキーとする連想配列を返すだけで、簡単にダッシュボード上にグラフを表示できます。

たとえば、ECサイトであれば注文数、ソーシャルメディアを利用していればその反応を表示するようにすればちょっと便利に使えます。

これはサンプルなので適当に、その日のエラーログ数を表示させてみました。

## サンプル内容

* `condition` ハンドラによる描画ON/OFF
* `handler` ハンドラによる描画用データ作成
* プラグイン設定変更時のキャッシュのクリア

##Contributing to Stats Sample

Fork, fix, then send me a pull request.

##Copyright
© 2013 Yuichi Takeuchi, released under the public domain
