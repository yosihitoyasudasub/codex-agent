# スタック選択ワークフロー

新規プロジェクト開始時に技術スタックをコンポーネント単位で選択し、
必要なファイルを組み合わせて生成する。

コンポーネント定義は `.codex/components/` に格納されている。

---

## クイック選択（パターン）

よくある構成をパターンとして用意している。パターンを選ぶか、「カスタム」で個別選択する。

| # | パターン名 | 用途 | UI | Backend | DB | Python |
|---|---|---|---|---|---|---|
| **1** | Web アプリ（標準） | CRUD・管理画面・ダッシュボード | Next.js | なし | SQLite | — |
| **2** | Web アプリ（本格） | スケールが必要な Web サービス | Next.js | なし | PostgreSQL | — |
| **3** | SPA + API | フロント/バック分離構成 | Vite+React | Hono | SQLite | — |
| **4** | 画像処理 Web アプリ | 画像アップロード・加工・変換 | Vite+React | FastAPI | SQLite | 画像処理 |
| **5** | AI・ML Web アプリ | 推論・チャット・モデル活用 | Next.js | FastAPI | PostgreSQL | ML・AI |
| **6** | カスタム | 上記に当てはまらない場合 | 個別選択 | 個別選択 | 個別選択 | 個別選択 |

### ユーザーへの提示文

```
利用可能なスタックパターン:

  1: Web アプリ（標準）   — Next.js + SQLite
  2: Web アプリ（本格）   — Next.js + PostgreSQL
  3: SPA + API           — Vite+React + Hono + SQLite
  4: 画像処理 Web アプリ  — Vite+React + FastAPI + SQLite + 画像処理ライブラリ
  5: AI・ML Web アプリ    — Next.js + FastAPI + PostgreSQL + ML・AIライブラリ
  6: カスタム            — コンポーネントを個別に選択

番号を選択してください（6を選ぶと個別選択に進みます）:
```

パターン 1〜5 が選択された場合は、対応するコンポーネントを自動的に決定して**ステップ2**に進む。
パターン 6（カスタム）が選択された場合は「個別選択項目」に進む。

---

## 個別選択項目（カスタム選択時のみ）

### UI フレームワーク（必須・1つ選択）

| 選択肢 | 説明 | 開発サーバー |
|---|---|---|
| **A: Next.js 15** | SSR/SSG/Server Actions。TypeScript でバックエンドも書ける | localhost:3000 |
| **B: Vite + React** | 軽量 SPA。バックエンドを別途選択する前提 | localhost:5173 |

### バックエンド（必須・1つ選択）

| 選択肢 | 説明 |
|---|---|
| **A: なし** | Next.js の API Routes / 外部 API で完結 |
| **B: FastAPI** | Python バックエンド。画像処理・ML 等に適する |
| **C: Hono** | TypeScript 軽量 API サーバー。Vite+React との組み合わせに適する |

### データベース（必須・1つ選択）

| 選択肢 | 説明 |
|---|---|
| **A: なし** | DB 不要（外部サービスや状態管理で完結） |
| **B: SQLite** | ファイル DB。自前 PC に最適。シンプル構成 |
| **C: PostgreSQL** | 本格 RDB。同時アクセスや複雑なクエリに対応 |

### Python ライブラリ（Backend で FastAPI を選択した場合のみ）

| 選択肢 | 内容 |
|---|---|
| **A: 汎用** | FastAPI + Uvicorn のみ。ライブラリは後で追加 |
| **B: 画像処理** | Pillow + OpenCV + NumPy |
| **C: ML・AI** | PyTorch + Transformers + LangChain |

---

## 実行手順

### ステップ1: パターンまたはカスタムを選択してもらう

クイック選択のパターン一覧をユーザーに提示する。
- パターン 1〜5 を選択 → コンポーネントを自動決定してステップ2へ進む
- パターン 6（カスタム）を選択 → 「個別選択項目」の各問いを順番に確認してステップ2へ進む

**パターン別コンポーネント対応表:**
| パターン | UI | Backend | DB | PythonLibs |
|---|---|---|---|---|
| 1 | nextjs | none | sqlite | — |
| 2 | nextjs | none | postgresql | — |
| 3 | vite-react | hono | sqlite | — |
| 4 | vite-react | fastapi | sqlite | image-processing |
| 5 | nextjs | fastapi | postgresql | ml-ai |

### ステップ2: コンポーネントファイルを読み込む

選択されたコンポーネントのファイルを読む:

```
UI 選択:
  A → .codex/components/ui/nextjs/{component.md, AGENTS-fragment.md, Dockerfile, docker-service.yml}
  B → .codex/components/ui/vite-react/{component.md, AGENTS-fragment.md, Dockerfile, docker-service.yml, nginx.conf}

Backend 選択:
  A → .codex/components/backend/none/component.md
  B → .codex/components/backend/fastapi/{component.md, AGENTS-fragment.md, Dockerfile, docker-service.yml, requirements-base.txt}
  C → .codex/components/backend/hono/{component.md, AGENTS-fragment.md, Dockerfile, docker-service.yml}

DB 選択:
  A → .codex/components/db/none/component.md
  B → .codex/components/db/sqlite/{component.md, AGENTS-fragment.md}
  C → .codex/components/db/postgresql/{component.md, AGENTS-fragment.md, docker-service.yml}

Python ライブラリ（FastAPI 選択時のみ）:
  A → .codex/components/python-libs/general/component.md
  B → .codex/components/python-libs/image-processing/{component.md, AGENTS-fragment.md, requirements.txt}
  C → .codex/components/python-libs/ml-ai/{component.md, AGENTS-fragment.md, requirements.txt}
```

### ステップ3: AGENTS.md の技術スタックセクションを更新する

`AGENTS.md` の `## 技術スタック` セクション（「未選択」と書かれた部分）を以下の内容で置き換える:

```markdown
## 技術スタック

> 選択済みスタック: UI=[選択] / Backend=[選択] / DB=[選択] / PythonLibs=[選択（FastAPI時のみ）]

[各コンポーネントの AGENTS-fragment.md の内容を順番に貼り付ける]

## Docker（ローカルサーバー運用）
\`\`\`bash
docker compose up -d      # 全サービス起動
docker compose down       # 停止
docker compose build      # 全イメージ再ビルド
\`\`\`
```

### ステップ4: Dockerfile をプロジェクトルートにコピーする

UI コンポーネントの Dockerfile をプロジェクトルートにコピーする:
```bash
# Next.js の場合
cp .codex/components/ui/nextjs/Dockerfile ./Dockerfile

# Vite+React の場合
cp .codex/components/ui/vite-react/Dockerfile ./Dockerfile
cp .codex/components/ui/vite-react/nginx.conf ./nginx.conf
```

Backend が FastAPI または Hono の場合:
```bash
mkdir -p ./api
cp .codex/components/backend/[fastapi|hono]/Dockerfile ./api/Dockerfile
```

### ステップ5: api/requirements.txt を生成する（FastAPI 選択時のみ）

`requirements-base.txt` と選択した Python ライブラリの `requirements.txt` を結合する:

```bash
# 汎用の場合
cp .codex/components/backend/fastapi/requirements-base.txt ./api/requirements.txt

# 画像処理の場合
cat .codex/components/backend/fastapi/requirements-base.txt \
    .codex/components/python-libs/image-processing/requirements.txt \
    > ./api/requirements.txt

# ML・AI の場合
cat .codex/components/backend/fastapi/requirements-base.txt \
    .codex/components/python-libs/ml-ai/requirements.txt \
    > ./api/requirements.txt
```

### ステップ6: docker-compose.yml を生成する

選択されたコンポーネントの docker-service.yml を組み合わせて `docker-compose.yml` を生成する。

**ひな形:**
```yaml
services:
[UIコンポーネントの docker-service.yml の内容]
[Backendコンポーネントの docker-service.yml の内容（なし以外）]
[DBコンポーネントの docker-service.yml の内容（なし以外）]
```

**depends_on の追加ルール:**
- Frontend は Backend が存在する場合 `depends_on: api` を追加
- Frontend と Backend は DB が存在する場合 `depends_on: db` を追加

**volumes セクションの追加ルール:**
- PostgreSQL を選択した場合、最後に以下を追加:
```yaml
volumes:
  postgres_data:
```

**環境変数の補完:**
- Backend が存在する場合、Frontend の environment に `API_URL=http://api:8000` を追加
- PostgreSQL を選択した場合、`DATABASE_URL=postgresql://app:password@db:5432/app` を各サービスの environment に追加

### ステップ7: .env.example を生成する（PostgreSQL 選択時）

```bash
# .env.example
POSTGRES_DB=app
POSTGRES_USER=app
POSTGRES_PASSWORD=password
DATABASE_URL=postgresql://app:password@db:5432/app
```

### ステップ8: data ディレクトリを作成する（SQLite 選択時）

```bash
mkdir -p ./data
touch ./data/.gitkeep
```

### ステップ9: 完了報告

以下を報告する:
- 選択されたコンポーネント一覧
- 生成・コピーされたファイル一覧
- 次のステップ: `setup-project.md` を参照して初回セットアップを実行

---

## 完了条件

- [ ] `AGENTS.md` の技術スタックセクションが選択内容に更新済み
- [ ] `Dockerfile` がプロジェクトルートに存在する
- [ ] `docker-compose.yml` がプロジェクトルートに存在する
- [ ] FastAPI 選択時: `api/Dockerfile` と `api/requirements.txt` が存在する
- [ ] Hono 選択時: `api/Dockerfile` が存在する
- [ ] PostgreSQL 選択時: `.env.example` が存在する
- [ ] SQLite 選択時: `data/` ディレクトリが存在する
