# Mock Gallery Saver

AI画像生成サイト風のダミーギャラリーと、そこから画像とメタデータを一括保存するブラウザ拡張機能のセットです。

> [!NOTE]
> 学習用の個人プロジェクトです。ギャラリーに掲載する画像はすべてダミー（フリー素材または自作）で、実在のサービスとは関係ありません。

## 概要

| 構成要素 | 内容 |
|---|---|
| **Gallery**（`gallery/`） | AI画像ギャラリーサイトを模したWebアプリ。画像一覧、無限スクロール、ログイン、JSON APIを持つ |
| **Extension**（`extension/`） | Gallery上の画像を検出し、プロンプトなどのメタデータと一緒に一括ダウンロードするブラウザ拡張 |

## 作った理由

- 卒業制作appでは触れない技術で個人的に気になっているもの（DOM操作・TypeScript・api）を学習したい。
- スケジュールを気にせず、作りたいものを作りながら幅広い技術を試したかった
- 「APIを作る側」と「APIを使う側」の両方を一人で作ることで、Webの仕組みを全体で理解したかった

## 主な機能（予定）

### Gallery
- [ ] 画像一覧ページ（サムネイル表示）
- [ ] 画像一覧JSON API（ページネーション対応）
- [ ] 無限スクロール
- [ ] ユーザー認証（ログインユーザーの画像のみ取得できるAPI）
- [ ] 画像ごとのメタデータ（プロンプト、seed、モデル名など）

### Extension
- [ ] ページ上の画像の検出と枚数表示
- [ ] 表示中の画像の一括ダウンロード
- [ ] 無限スクロールで追加された画像の自動検出
- [ ] ダウンロードキューとレート制限
- [ ] メタデータのJSON保存
- [ ] ファイル名ルールの設定（例：`{date}_{seed}.png`）
- [ ] ダウンロード履歴の管理（重複ダウンロードの防止）
- [ ] 設定画面

## 構成

```
mock-gallery-saver/
├── gallery/            # Rails製ダミーギャラリー
├── extension/          # ブラウザ拡張（WXT + TypeScript）
│   └── src/
│       ├── core/       # ダウンロードキュー、ファイル名ルールなど共通処理
│       ├── adapters/   # サイトごとの画像・メタデータ取得処理
│       └── ui/         # Popup、設定画面
├── docker-compose.yml
└── README.md
```

拡張機能は、サイトごとに違う部分（画像とメタデータの取り方）を `adapters/` に分けています。対応サイトを増やすときは adapter を1つ追加するだけで済む設計です。

## 技術スタック

| 分類 | 技術 |
|---|---|
| Gallery | Ruby on Rails, PostgreSQL, Active Storage |
| Extension | TypeScript, WXT, Chrome Extensions Manifest V3 |
| テスト | RSpec, Vitest, Playwright |
| 開発環境 | Docker / Docker Compose |
| CI | GitHub Actions（予定） |

## API仕様（暫定）

### `GET /api/images`

画像一覧を返します。

| パラメータ | 型 | 説明 |
|---|---|---|
| `page` | integer | ページ番号（省略時は1） |

```json
{
  "images": [
    {
      "id": 123,
      "url": "/images/123/original.png",
      "thumbnail_url": "/images/123/thumb.png",
      "prompt": "a cat sitting on a window, watercolor",
      "seed": 482913,
      "model": "mock-diffusion-v1",
      "created_at": "2026-11-01T12:00:00+09:00"
    }
  ],
  "next_page": 2
}
```

最終ページでは `next_page` が `null` になります。

## セットアップ

### Gallery
```bash
docker compose build
docker compose run --rm web bin/rails db:prepare
docker compose up
```
http://localhost:3000 で起動します。

## ロードマップ

- [ ] **M1：つながる** — Galleryの一覧ページとAPIを作り、拡張機能のPopupに画像枚数を表示する
- [ ] **M2：保存できる** — 表示中の画像を一括ダウンロードする
- [ ] **M3：たくさん保存できる** — 無限スクロールへの対応、ダウンロードキュー、レート制限
- [ ] **M4：整理できる** — メタデータのJSON保存、ファイル名ルール
- [ ] **M5：ログインしても使える** — 認証付きAPIへの対応
- [ ] **M6：使いやすくする** — 設定画面、ダウンロード履歴

## このプロジェクトで学ぶこと

- DOM操作と `MutationObserver` による動的なページへの対応
- HTTP、Cookie、セッション、CORSなどWebの基礎
- Manifest V3拡張機能の構造（Content Script / Service Worker / Popup）とメッセージパッシング
- REST API設計とページネーション
- キュー、リトライ、レート制限による安定した一括処理
- Adapterパターンを使った拡張しやすい設計

## 開発記録

進捗や詰まったところは [Issues](../../issues) と Pull Request に記録しています。
