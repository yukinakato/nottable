def create_markdown_note(user, title, content)
  note = MarkdownNote.create(content: content)
  user.notes.create(title: title, note_entity: note)
end

def create_rich_note(user, title, content)
  note = RichNote.create
  ActionText::RichText.create(record: note, name: "content", body: content)
  user.notes.create(title: title, note_entity: note)
end

u1 = User.create(display_name: Constants::GUEST_DISPLAY_NAME,
                 email: Constants::GUEST_EMAIL,
                 password: Devise.friendly_token[0, 20],
                 introduce: "プログラミング学習中です。世の役に立つアプリケーションを開発できるよう頑張ります。",
                 avatar: Rack::Test::UploadedFile.new(Rails.root.join("spec", "factories", "programmer.png")))

u2 = User.create(display_name: "花子＠ランニング好き",
                 email: "hanako@example.com",
                 password: Devise.friendly_token[0, 20],
                 introduce: "健康のため、ランニングを行っています。美容や健康に関することを記録していきたいと思います。",
                 avatar: Rack::Test::UploadedFile.new(Rails.root.join("spec", "factories", "runner.png")))

u3 = User.create(display_name: "太郎＠自作PC始めました",
                 email: "taro@example.com",
                 password: Devise.friendly_token[0, 20],
                 introduce: "最近自作パソコンに挑戦しています。ゲームが快適にできるハイスペックなマシンを作りたいです！",
                 avatar: Rack::Test::UploadedFile.new(Rails.root.join("spec", "factories", "diypc.png")))

u4 = User.create(display_name: "駆け出しDTMer",
                 email: "dtmer@example.com",
                 password: Devise.friendly_token[0, 20],
                 introduce: "作曲の勉強を始めました！！！",
                 avatar: Rack::Test::UploadedFile.new(Rails.root.join("spec", "factories", "dtmer.png")))

u5 = User.create(display_name: "ともこ＠ねこカフェ行きたい",
                 email: "tomoko@example.com",
                 password: Devise.friendly_token[0, 20],
                 introduce: "猫が好き",
                 avatar: Rack::Test::UploadedFile.new(Rails.root.join("spec", "factories", "cat.png")))

create_markdown_note(u1, "ようこそ", <<~'EOS'
### Nottable へようこそ！

**表現力豊かなノートを作成しましょう！**

このアプリケーションの作成にあたっては、[Rails Guides](https://edgeguides.rubyonrails.org/) に何度も助けられました。

カレーの材料リストも自由自在

* お肉
* たまねぎ
* じゃがいも
* にんじん

```c
#include <stdio.h>

int main(void) {
    printf("Welcome to Nottable");
    return 0;
}
```

左のメニューから、違うノートを表示させてみましょう！
EOS
)

create_markdown_note(u1, "機能説明", <<~'EOS'
### マークダウン形式が使えます

使い慣れたマークダウン形式で、**表現力豊かな**ノートを作成しましょう！

タイトル下のメニューはそれぞれ、ブックマーク、編集、PDFダウンロードとなっております。

#### 上部メニューの「新規ノート」から、新しいノートを作成してみましょう。

* 「プライベートにする」にチェックを入れると、検索にかからなくなり、他の人から内容が見られなくなります。

#### 気になるジャンルの投稿をする人をフォローしよう

* フォローしている人がノートを作成すると、通知が届きます。見逃さないようにしましょう！

*※なお、ゲストユーザーのプロフィール情報は編集できません。予めご了承下さい。*

EOS
)

n = create_rich_note(u1, "ノート２作目！", <<~'EOS'
<strong>リッチテキスト</strong>モードを使うと<em>表現力豊かな</em>テキストを作成できます。
<br><br><blockquote>便利〜！</blockquote>
EOS
)

create_markdown_note(u1, "注意事項", <<~'EOS'
本アプリは試験運用中のため、予告なくデータベースがリセットされることがあります。予めご了承下さい。
EOS
)

u1.bookmark(n)
u1.follow(u2)
u1.follow(u3)
u1.follow(u4)

r = Relationship.create(follower: u5, followed: u1)
u1.notifications.create(notify_entity: r)

n = create_markdown_note(u3, "欲しいパーツリスト", <<~'EOS'
次に作るパソコンは以下のような構成にしようと思う。

* Ryzen 9 5900X
* X570 のマザーボード
* メモリ 64 GB
* SSD と HDD は、使い回し
* 電源 650 W

予算的に、5800X にするかも・・・。
EOS
)

u1.notifications.create(notify_entity: n)

n = create_markdown_note(u4, "いいヘッドホンが欲しい", <<~'EOS'
#### ヘッドホン壊れた

ので、新しいものが欲しい。予算は２万円前後。

* SHURE
* AKG
* オーディオテクニカ

どのメーカーにするか悩む・・・。
EOS
)

u1.notifications.create(notify_entity: n)

n = create_markdown_note(u2, "朝すっきり目覚める方法！", <<~'EOS'
以下のことに気を付ける。

* 適度に運動する（ランニング！）
* コーヒーは夕方までにする。
* 寝る前はあまりスマホをみない

お風呂でふくらはぎをマッサージするのもおすすめ。
EOS
)

u1.notifications.create(notify_entity: n)
u1.bookmark(n)

n = create_markdown_note(u2, "ランニングはじめました", <<~'EOS'
最近、ランニングをはじめました！仕事の後、１時間ほど家の近所を走っています。

終わった後のシャワーが最高なんですよね。

雨が降っていない日はほぼ毎日行っています。半年前よりも**３キロ**落とすことに成功しました！

* 初めは、30 分ぐらいから始める
* 慣れてきたら、坂道の多いルートを走ってみる
* 徐々に距離も伸ばしていく

思いつき次第追記していくので、興味があったらブックマークしてください！
EOS
)

u1.notifications.create(notify_entity: n)

create_markdown_note(u5, "猫カフェ行きたい", <<~'EOS'
今住んでいるアパートがペット禁止だから、猫カフェに行きたいです
EOS
)
