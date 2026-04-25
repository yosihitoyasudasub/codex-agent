### UI: Next.js 15
- Next.js 15 (App Router), React 19, TypeScript 5.x
- Tailwind CSS v4
- パッケージマネージャー: npm

#### ビルド・検証コマンド
```bash
npm run dev               # 開発サーバー (localhost:3000)
npm run build             # プロダクションビルド
npm start                 # プロダクション起動
npx tsc --noEmit          # 型チェック
npx jest                  # テスト全体
npm run lint              # リント
```

#### テスト配置
| 層 | テスト種別 | 配置 |
|---|---|---|
| ビジネスロジック | UT | `src/lib/__tests__/` |
| Server Actions / API Routes | Integration | `src/app/**/__tests__/` |
| Component | Component Test | コロケーション `__tests__/` |
| E2E | Playwright | `e2e/` |
