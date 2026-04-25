### Backend: Hono
- Hono (最新), TypeScript 5.x, Node.js 22
- パッケージマネージャー: npm

#### ビルド・検証コマンド（api/ ディレクトリ内）
```bash
npm run dev               # 開発サーバー (localhost:8000)
npm run build             # プロダクションビルド
npx tsc --noEmit          # 型チェック
npx jest                  # テスト全体
```

#### テスト配置
| 層 | テスト種別 | 配置 |
|---|---|---|
| ビジネスロジック | UT | `api/src/__tests__/` |
| API エンドポイント | Integration | `api/tests/integration/` |
