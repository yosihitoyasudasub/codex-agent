# Backend: FastAPI

## 概要
Python 製の高速非同期 Web API フレームワーク。
画像処理・ML 推論・重い計算処理など Python が得意な処理を担当する。

## 適した用途
- 画像処理・動画処理
- AI / ML 推論
- Python ライブラリを活用したい処理
- フロントエンドと処理エンジンを明確に分離したい場合

## 通信方式
- UI → FastAPI: HTTP（BFF 経由またはリバースプロキシ経由）
- ブラウザから FastAPI に直接アクセスさせない

## 生成ファイル
- `api/Dockerfile`
- `api/main.py`（スケルトン）
- `api/requirements.txt`（python-libs 選択により内容が決まる）
- `docker-compose.yml` に `api` サービスを追加

## 開発サーバー
`localhost:8000`（内部のみ。UI 経由でアクセス）
