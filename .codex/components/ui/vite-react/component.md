# UI: Vite + React

## 概要
Vite でビルドする SPA（シングルページアプリケーション）。
API は別途 Backend コンポーネントが必要（または外部 API を利用）。

## 適した用途
- フロントエンドと API を明確に分離したい場合
- 静的ホスティングで配信する SPA
- Backend に FastAPI / Hono を選択する場合

## 制約
- Backend を「なし」にした場合、外部 API に依存する構成になる

## 生成ファイル
- `Dockerfile` （nginx でビルド成果物を配信）
- `nginx.conf`
- `docker-compose.yml` に `frontend` サービスを追加

## 開発サーバー
`localhost:5173`
