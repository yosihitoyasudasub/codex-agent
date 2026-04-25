# DB: PostgreSQL

## 概要
本格的なオープンソース RDB。同時アクセス・大規模データ・複雑なクエリに対応。
Docker Compose で `db` サービスとして起動し、データを volume で永続化する。

## 適した用途
- 同時書き込みが多い用途
- 将来的なスケールアップを想定する場合
- 複雑なクエリ・トランザクションが必要な場合

## ORM
- TypeScript 側: Drizzle ORM（postgres ドライバ）
- Python 側: SQLAlchemy（FastAPI 選択時）

## 環境変数（.env に設定）
```
POSTGRES_DB=app
POSTGRES_USER=app
POSTGRES_PASSWORD=password
DATABASE_URL=postgresql://app:password@db:5432/app
```

## 生成ファイル
- `docker-compose.yml` に `db` サービスを追加
- `.env.example`
