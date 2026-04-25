# MY_APP_NAME プロジェクト

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
npx drizzle-kit migrate   # DBマイグレーション実行
npx drizzle-kit generate  # マイグレーションファイル生成
```

## Docker（ローカルサーバー運用）
```bash
docker compose up -d      # バックグラウンドで起動（ポート3000）
docker compose down       # 停止
docker compose build      # イメージ再ビルド
```
SQLiteデータは `data/` ディレクトリにマウントされ永続化される。

## スペック駆動開発ルール

### 実装前の確認（必須）
1. `AGENTS.md` を読む
2. `docs/` 配下の永続ドキュメントを読む
3. 既存の類似実装をキーワード検索する
4. 既存パターンを理解してから実装開始

### ドキュメント構造
- 永続ドキュメント: `docs/` — プロジェクト全体の設計（北極星）
- 下書き・アイデア: `docs/ideas/`
- 作業単位: `.steering/[YYYYMMDD]-[タスク名]/`（requirements.md, design.md, tasklist.md, issues.md, handoff.md, feedback.md）

---

## ワークフロー

### 新機能実装（3エージェントハーネス）

```bash
bash scripts/codex-add-feature.sh [機能名]
```

内部的に以下を実行する:
1. `bash scripts/codex-plan.sh [機能名]` — 独立コンテキストでPlannerを起動
2. Generator（このセッション）がスプリント単位で実装
3. `bash scripts/codex-evaluate.sh [steering-dir] [sprint] [files]` — 独立コンテキストでEvaluatorを起動

スクリプトを使わずに手動で進める場合は `.codex/workflows/add-feature.md` を参照。

### 初回セットアップ
`.codex/workflows/setup-project.md` を参照。

### ドキュメントレビュー
`.codex/agents/doc-reviewer.md` の指示をプロンプトに含め、対象ファイルを指定する。

---

## ステアリングファイル管理

### 作成（Plannerが担当）
テンプレートは `.codex/templates/steering/` に格納。

各ファイルの役割:
- `requirements.md` — 機能要件と受け入れ基準
- `design.md` — 実装設計（アーキテクチャ・コンポーネント・データフロー）
- `tasklist.md` — スプリント構成のタスクリスト（検証ゲート付き）
- `issues.md` — 実装前レビュー（致命的/重要/軽微）
- `handoff.md` — フェーズ間コンテキスト引き継ぎ
- `feedback.md` — Evaluatorフィードバック蓄積

### 実装時のタスク管理（Generator）

**必須ルール:**
- `tasklist.md` を常に参照しながら実装
- タスク開始時: `[ ]` → `[x]` に即時更新
- タスク完了時: 完了記録を即時更新
- **全タスクが `[x]` になるまで作業を継続する**
- タスクスキップ禁止（技術的理由がある場合のみ、理由を明記してスキップ可）

**スプリント境界でのEvaluator呼び出し:**
スプリントの全タスクが完了したら:
1. `handoff.md` を現在のスプリント完了状態で更新
2. `bash scripts/codex-evaluate.sh [steering-dir] [sprint番号] "[変更ファイル一覧]"` を実行
3. 合格 → 次スプリントへ / 差し戻し → feedback.md の指示に従い修正して再実行

**フェーズ0ゲート（実装開始前）:**
`issues.md` の致命的問題が解決されるまで実装に進まない。
解決後、`tasklist.md` に以下を追加して完了マークを付ける:
```
## フェーズ0: issues.md 永続ドキュメント反映
- [x] issues.md の全対策を docs/ に反映完了
```

### 永続ドキュメント反映（実装完了後）
全スプリント完了後、`docs/` との乖離を確認・更新する:
- 関数・インターフェース変更 → `docs/functional-design.md`
- ファイル追加・削除 → `docs/architecture.md`, `docs/repository-structure.md`
- UI変更 → `docs/screen-design.md`, `docs/design-system.md`
- 新機能追加 → `docs/product-requirements.md`
- 用語変更 → `docs/glossary.md`

### 振り返り（実装後）
`tasklist.md` の振り返りセクションに記録:
- 実装完了日
- 計画と実績の差分
- 学んだこと
- ハーネスへのフィードバック（Plannerの計画精度・Evaluatorの検証精度・スプリント粒度）

---

## テスト戦略

### テストピラミッド
- Unit Test（多数・高速）: ビジネスロジック・Engine・Store層
- Integration Test（中程度）: Page・Store統合
- E2E Test（少数・重要フロー）: Playwright

### 層別テスト戦略
| 層 | テスト種別 | 配置 |
|---|---|---|
| ビジネスロジック | UT | `src/lib/__tests__/` |
| Server Actions / API | Integration | `src/app/**/__tests__/` |
| Component | Component Test | コロケーション `__tests__/` |
| DB層（Drizzle） | Integration | `src/db/__tests__/` |
| E2E | Playwright | `e2e/` |

### テストルール
- ビジネスロジックを優先してテスト（UI の細部は後回し）
- AAA パターン（Arrange-Act-Assert）
- `any` の乱用禁止
- テストファイルはソースと同階層の `__tests__/` に配置

---

## コーディング規約
`docs/development-guidelines.md` を参照。主要ルール:
- 命名: camelCase（変数・関数）/ PascalCase（コンポーネント・型）/ UPPER_SNAKE_CASE（定数）
- 型: `any` 禁止、明示的な型定義を優先
- コメント: WHY が非自明な場合のみ（WHAT のコメント禁止）
- 単一責務の原則を遵守
