# Backend: Hono

## 概要
TypeScript 製の軽量高速 Web フレームワーク。
Vite+React の SPA から呼ばれる REST API サーバーとして機能する。

## 適した用途
- Vite+React と組み合わせた TypeScript フルスタック構成
- Edge / Cloudflare Workers への将来的な移行を視野に入れる場合
- 軽量な API サーバーが必要な場合

## 生成ファイル
- `api/Dockerfile`
- `docker-compose.yml` に `api` サービスを追加

## 開発サーバー
`localhost:8000`（内部のみ。UI 経由でアクセス）
