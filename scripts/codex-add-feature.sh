#!/bin/bash
# 新機能追加ワークフロー: 3エージェントハーネスを起動する
# 使い方: bash scripts/codex-add-feature.sh [機能名]

set -e

FEATURE="$1"

if [ -z "$FEATURE" ]; then
  echo "Usage: bash scripts/codex-add-feature.sh [機能名]" >&2
  echo "Example: bash scripts/codex-add-feature.sh ユーザー認証" >&2
  exit 1
fi

DATE=$(date +%Y%m%d)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STEERING="${PROJECT_ROOT}/.steering/${DATE}-${FEATURE}"

echo ""
echo "======================================================"
echo "  3エージェントハーネス: ${FEATURE}"
echo "======================================================"
echo ""

# フェーズ1: Planner（独立コンテキスト）
echo "--- Phase 1: Planning ---"
bash "${PROJECT_ROOT}/scripts/codex-plan.sh" "$FEATURE"
echo ""

# フェーズ2: Generator（このセッション）
echo "--- Phase 2: Implementation ---"
WORKFLOW="$(cat "${PROJECT_ROOT}/.codex/workflows/add-feature.md")"

echo "ワークフローを読み込みました。Generatorとして実装を開始します。"
echo ""
echo "Evaluator の呼び出しコマンド:"
echo "  bash scripts/codex-evaluate.sh \"${STEERING}\" [スプリント番号] \"[変更ファイル]\""
echo ""

codex --approval-mode full-auto "${WORKFLOW}

---
## 実行コンテキスト

機能名: ${FEATURE}
ステアリングディレクトリ: ${STEERING}
プロジェクトルート: ${PROJECT_ROOT}

Evaluator を起動する際は以下のコマンドを使用してください:
  bash ${PROJECT_ROOT}/scripts/codex-evaluate.sh \"${STEERING}\" [スプリント番号] \"[変更ファイルパス一覧]\"

ワークフローの全ステップを完了条件まで自律的に実行してください。"

echo ""
echo "======================================================"
echo "  実装完了: ${FEATURE}"
echo "======================================================"
