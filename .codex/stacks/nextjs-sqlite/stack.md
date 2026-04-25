# スタック: nextjs-sqlite

## 概要
Next.js フロントエンド + SQLite データベースのみで完結する Web アプリ構成。
Python バックエンドは不要で、ビジネスロジックを Server Actions / API Routes に実装する。

## 適した用途
- 一般的な Web アプリ（CRUD・管理画面・ダッシュボード等）
- バックエンド処理が TypeScript で実装できる場合
- シンプルな構成を優先する場合

## 技術スタック
- Next.js 15 (App Router), React 19, TypeScript 5.x
- Tailwind CSS v4
- Drizzle ORM + SQLite（`data/app.db`）
- パッケージマネージャー: npm

## 生成されるファイル
- `Dockerfile` — Next.js standalone マルチステージビルド
- `docker-compose.yml` — シングルサービス構成（ポート 3000）
- `AGENTS.md` の技術スタックセクション更新
