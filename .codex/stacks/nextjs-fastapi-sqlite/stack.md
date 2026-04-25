# スタック: nextjs-fastapi-sqlite

## 概要
Next.js フロントエンド（BFF）+ FastAPI Python バックエンド + SQLite の2サービス構成。
画像処理・機械学習・重い計算処理など、Python が得意な処理をバックエンドに分離する。

## 適した用途
- 画像処理・動画処理アプリ
- AI / ML 推論を含む Web アプリ
- Python ライブラリ（OpenCV・Pillow・NumPy・PyTorch 等）を活用したい場合
- フロントエンドと処理エンジンを明確に分離したい場合

## 技術スタック

### フロントエンド（Next.js）
- Next.js 15 (App Router), React 19, TypeScript 5.x
- Tailwind CSS v4
- Drizzle ORM + SQLite（`data/app.db`）— メタデータ・ユーザーデータ管理
- パッケージマネージャー: npm

### バックエンド（FastAPI）
- Python 3.12
- FastAPI — 非同期 Web API フレームワーク
- Pillow — 基本画像処理（リサイズ・クロップ・フィルタ・フォーマット変換）
- OpenCV — 高度画像処理（エッジ検出・色解析・物体検出）
- NumPy — 配列・行列演算
- Uvicorn — ASGI サーバー

## 通信方式
- ブラウザ → Next.js（UI + BFF）: HTTP
- Next.js → FastAPI: HTTP（multipart/form-data で画像転送）
- FastAPI はブラウザに直接公開しない（BFF 経由のみ）

## 生成されるファイル
- `Dockerfile` — Next.js standalone マルチステージビルド
- `docker-compose.yml` — 2サービス構成（frontend: 3000, api: 8000 内部）
- `api/Dockerfile` — FastAPI コンテナ
- `AGENTS.md` の技術スタックセクション更新
