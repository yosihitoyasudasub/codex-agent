## 技術スタック
- Next.js 15 (App Router), React 19, TypeScript 5.x
- Tailwind CSS v4
- Drizzle ORM + SQLite（`data/app.db`）
- パッケージマネージャー: npm

## ビルド・検証コマンド
```bash
npm run dev               # 開発サーバー (localhost:3000)
npm run build             # プロダクションビルド
npm start                 # プロダクション起動
npx tsc --noEmit          # 型チェック
npx jest                  # テスト全体
npx jest tests/unit/[ファイル]  # 単一テスト（優先）
npm run lint              # リント
npx drizzle-kit generate  # マイグレーションファイル生成
npx drizzle-kit migrate   # DBマイグレーション実行
```

## Docker（ローカルサーバー運用）
```bash
docker compose up -d      # バックグラウンドで起動（ポート 3000）
docker compose down       # 停止
docker compose build      # イメージ再ビルド
```
SQLite データは `data/` ディレクトリにマウントされ永続化される。

## テスト配置（スタック別）
| 層 | テスト種別 | 配置 |
|---|---|---|
| ビジネスロジック | UT | `src/lib/__tests__/` |
| Server Actions / API Routes | Integration | `src/app/**/__tests__/` |
| Component | Component Test | コロケーション `__tests__/` |
| DB層（Drizzle） | Integration | `src/db/__tests__/` |
| E2E | Playwright | `e2e/` |
