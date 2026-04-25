## 技術スタック

### フロントエンド（Next.js）
- Next.js 15 (App Router), React 19, TypeScript 5.x
- Tailwind CSS v4
- Drizzle ORM + SQLite（`data/app.db`）
- パッケージマネージャー: npm

### バックエンド（FastAPI）
- Python 3.12 + FastAPI + Uvicorn
- Pillow, OpenCV, NumPy

## ビルド・検証コマンド

### フロントエンド
```bash
npm run dev               # 開発サーバー (localhost:3000)
npm run build             # プロダクションビルド
npm start                 # プロダクション起動
npx tsc --noEmit          # 型チェック
npx jest                  # テスト全体
npm run lint              # リント
npx drizzle-kit generate  # マイグレーションファイル生成
npx drizzle-kit migrate   # DBマイグレーション実行
```

### バックエンド
```bash
cd api
pip install -r requirements.txt   # 依存インストール
uvicorn main:app --reload          # 開発サーバー (localhost:8000)
pytest                             # テスト全体
pytest tests/unit/[ファイル]       # 単一テスト（優先）
```

## Docker（ローカルサーバー運用）
```bash
docker compose up -d      # 全サービス起動（frontend: 3000, api: 内部 8000）
docker compose down       # 停止
docker compose build      # 全イメージ再ビルド
docker compose build api  # API のみ再ビルド
```
SQLite データは `data/` ディレクトリにマウントされ永続化される。
アップロード画像は `data/uploads/` に保存される。

## テスト配置（スタック別）
| 層 | テスト種別 | 配置 |
|---|---|---|
| フロント: ビジネスロジック | UT | `src/lib/__tests__/` |
| フロント: API Routes（BFF） | Integration | `src/app/api/**/__tests__/` |
| フロント: Component | Component Test | コロケーション `__tests__/` |
| フロント: DB層（Drizzle） | Integration | `src/db/__tests__/` |
| バックエンド: 画像処理ロジック | UT | `api/tests/unit/` |
| バックエンド: APIエンドポイント | Integration | `api/tests/integration/` |
| E2E | Playwright | `e2e/` |
