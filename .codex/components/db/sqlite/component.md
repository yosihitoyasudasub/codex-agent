# DB: SQLite

## 概要
ファイルベースの軽量 RDB。別プロセス不要で自前 PC サーバーに最適。
データは `data/app.db` に保存され、Docker volume でマウントして永続化する。

## 適した用途
- 個人・小チーム向け Web アプリ
- 同時書き込みが少ない用途
- セットアップをシンプルに保ちたい場合

## ORM
- TypeScript 側: Drizzle ORM
- Python 側: SQLAlchemy（FastAPI 選択時）

## 生成ファイル
- `data/` ディレクトリ（`data/.gitkeep`）
- AGENTS.md にマイグレーションコマンドを追記
