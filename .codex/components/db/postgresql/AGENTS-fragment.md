### DB: PostgreSQL 16
- PostgreSQL 16（Docker サービス `db`）
- TypeScript: Drizzle ORM（postgres ドライバ）
- Python (FastAPI): SQLAlchemy + asyncpg（選択時）
- 接続: `DATABASE_URL=postgresql://app:password@db:5432/app`

#### マイグレーションコマンド（TypeScript 側）
```bash
npx drizzle-kit generate  # マイグレーションファイル生成
npx drizzle-kit migrate   # マイグレーション実行
```

#### 環境変数（`.env` に設定）
```
POSTGRES_DB=app
POSTGRES_USER=app
POSTGRES_PASSWORD=password
DATABASE_URL=postgresql://app:password@db:5432/app
```
