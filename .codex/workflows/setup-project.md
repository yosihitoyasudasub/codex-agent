# 初回プロジェクトセットアップ

永続ドキュメントを対話的に作成し、開発環境を構築する。

## 実行前の確認

`docs/ideas/` ディレクトリ内のファイルを確認する:
```bash
ls docs/ideas/
```
- ファイルが存在する場合 → その内容を元に PRD を作成
- ファイルが存在しない場合 → 対話形式で PRD を作成

## 手順

### ステップ0: インプットの読み込み

`docs/ideas/` 内のマークダウンファイルを全て読む。

### ステップ1: プロダクト要求定義書の作成

1. `.codex/templates/docs/prd-template.md` を読む（存在する場合）
2. `docs/ideas/` の内容を元に `docs/product-requirements.md` を作成:
   - 詳細なユーザーストーリー
   - 受け入れ条件
   - 非機能要件
   - 成功指標（KPI）
3. ユーザーに確認を求め、**承認されるまで待機**

以降のステップはプロダクト要求定義書の内容を元に自動的に作成する。

### ステップ2: 機能設計書の作成

`docs/product-requirements.md` を読み、`docs/functional-design.md` を作成:
- 各機能の詳細仕様
- 画面フロー
- データモデル
- API インターフェース

### ステップ3: アーキテクチャ設計書の作成

既存ドキュメントを読み、`docs/architecture.md` を作成:
- アーキテクチャ概要
- コンポーネント設計
- データフロー
- エラーハンドリング方針
- テスト戦略
- 依存関係・ディレクトリ構造
- 実装順序
- セキュリティ・パフォーマンス方針

### ステップ4: リポジトリ構造定義書の作成

`docs/repository-structure.md` を作成:
- ディレクトリ構造の定義
- 各ディレクトリの役割
- ファイル命名規則

### ステップ5: 開発ガイドラインの作成

`docs/development-guidelines.md` を作成:
- コーディング規約（TypeScript/Next.js App Router）
- Git 運用ルール
- テスト方針
- コードレビュー基準

### ステップ6: 用語集の作成

`docs/glossary.md` を作成:
- プロダクト用語
- 技術用語
- 略語・略称

### ステップ7: ディレクトリ構造の作成

リポジトリ構造定義書に従い、必要なディレクトリとファイルを作成する。

### ステップ8: 環境構築と動作確認

```bash
# Next.js プロジェクト初期化（未作成の場合）
npx create-next-app@latest . --typescript --tailwind --app --src-dir --import-alias "@/*"

# 追加パッケージのインストール
npm install drizzle-orm better-sqlite3
npm install -D drizzle-kit @types/better-sqlite3

# DB マイグレーション
npx drizzle-kit generate
npx drizzle-kit migrate

# 開発サーバー起動確認
npm run dev
```

Docker で起動確認する場合:
```bash
npm run build
docker compose build
docker compose up -d
# http://localhost:3000 にアクセス
```

## 完了条件

- `docs/product-requirements.md` 作成済み
- `docs/functional-design.md` 作成済み
- `docs/architecture.md` 作成済み
- `docs/repository-structure.md` 作成済み
- `docs/development-guidelines.md` 作成済み
- `docs/glossary.md` 作成済み
- ディレクトリ構造作成済み
- 開発サーバー起動確認済み

## 完了後の使い方

- 機能追加: `bash scripts/codex-add-feature.sh [機能名]`
- ドキュメントレビュー: `cat .codex/agents/doc-reviewer.md` の指示をプロンプトに含める
