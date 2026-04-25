### Backend: FastAPI
- Python 3.12 + FastAPI + Uvicorn
- ※ Python ライブラリは選択内容により異なる（requirements.txt 参照）

#### ビルド・検証コマンド（api/ ディレクトリ内）
```bash
pip install -r requirements.txt   # 依存インストール
uvicorn main:app --reload          # 開発サーバー (localhost:8000)
pytest                             # テスト全体
pytest tests/unit/[ファイル]       # 単一テスト（優先）
```

#### テスト配置
| 層 | テスト種別 | 配置 |
|---|---|---|
| 処理ロジック | UT | `api/tests/unit/` |
| API エンドポイント | Integration | `api/tests/integration/` |
