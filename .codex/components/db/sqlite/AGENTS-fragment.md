### DB: SQLite
- SQLite（`data/app.db`）— ファイルDB、別プロセス不要
- TypeScript: Drizzle ORM
- Python (FastAPI): SQLAlchemy + aiosqlite（選択時）

#### マイグレーションコマンド（TypeScript 側）
```bash
npx drizzle-kit generate  # マイグレーションファイル生成
npx drizzle-kit migrate   # マイグレーション実行
```
