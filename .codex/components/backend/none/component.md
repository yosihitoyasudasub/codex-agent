# Backend: なし

## 概要
独立したバックエンドサービスを持たない。
Next.js の Server Actions / API Routes、または外部 API で処理を完結させる。

## 適した用途
- UI が Next.js で、TypeScript でバックエンドロジックを実装できる場合
- 外部 API（SaaS・REST API）を呼び出すだけの場合

## 生成ファイル
なし（docker-compose.yml に api サービスは追加されない）
