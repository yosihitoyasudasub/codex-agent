# スタック選択ワークフロー

新規プロジェクト開始時に技術スタックを選択し、必要なファイルを生成する。
このワークフローは `setup-project.md` の前に必ず実行する。

---

## 利用可能なスタック

### A: nextjs-sqlite
**用途**: 一般的な Web アプリ（CRUD・管理画面・ダッシュボード等）
- Next.js 15 + TypeScript + Tailwind CSS v4 + Drizzle ORM + SQLite
- バックエンド処理は TypeScript（Server Actions / API Routes）で実装
- Docker: シングルサービス（ポート 3000）

### B: nextjs-fastapi-sqlite
**用途**: 画像処理・AI/ML・重い計算処理を含む Web アプリ
- Next.js 15 + TypeScript + Tailwind CSS v4 + Drizzle ORM + SQLite（フロント）
- FastAPI + Python 3.12 + Pillow + OpenCV + NumPy（バックエンド）
- Docker: 2サービス構成（frontend: 3000, api: 内部 8000）

---

## 実行手順

### ステップ1: ユーザーに確認

以下を提示してスタックを選択してもらう:
```
利用可能なスタック:
  A: nextjs-sqlite          — Web アプリ（TypeScript のみ）
  B: nextjs-fastapi-sqlite  — Web アプリ + Python バックエンド

どのスタックを使用しますか？
```

### ステップ2: スタックテンプレートを読み込む

選択されたスタック（例: A → `nextjs-sqlite`）の以下ファイルを読む:
- `.codex/stacks/[スタック名]/stack.md`
- `.codex/stacks/[スタック名]/AGENTS-stack.md`

### ステップ3: AGENTS.md を更新する

`AGENTS.md` の `## 技術スタック` セクション（「未選択」と書かれた部分）を、
`AGENTS-stack.md` の内容で**置き換える**。

置き換え対象（先頭から `---` までの全体）:
```
## 技術スタック

> **未選択**。...
...
利用可能なスタック一覧: `.codex/stacks/` を参照。
```

### ステップ4: Docker ファイルをプロジェクトルートにコピーする

**A: nextjs-sqlite の場合:**
```bash
cp .codex/stacks/nextjs-sqlite/Dockerfile ./Dockerfile
cp .codex/stacks/nextjs-sqlite/docker-compose.yml ./docker-compose.yml
```

**B: nextjs-fastapi-sqlite の場合:**
```bash
cp .codex/stacks/nextjs-fastapi-sqlite/Dockerfile ./Dockerfile
cp .codex/stacks/nextjs-fastapi-sqlite/docker-compose.yml ./docker-compose.yml
mkdir -p ./api
cp .codex/stacks/nextjs-fastapi-sqlite/api/Dockerfile ./api/Dockerfile
```

### ステップ5: 完了報告

以下を報告する:
- 選択されたスタック名
- コピーされたファイル一覧
- 次のステップ: `setup-project.md` を参照して初回セットアップを実行

---

## 完了条件

- [ ] `AGENTS.md` の技術スタックセクションがスタック固有の情報に更新済み
- [ ] `Dockerfile` がプロジェクトルートに存在する
- [ ] `docker-compose.yml` がプロジェクトルートに存在する
- [ ] B を選択した場合: `api/Dockerfile` が存在する
