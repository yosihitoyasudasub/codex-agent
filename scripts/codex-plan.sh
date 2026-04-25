#!/bin/bash
# Planner: 独立コンテキストで企画フェーズを実行する
# 使い方: bash scripts/codex-plan.sh [機能名]

set -e

FEATURE="$1"

if [ -z "$FEATURE" ]; then
  echo "Usage: bash scripts/codex-plan.sh [機能名]" >&2
  exit 1
fi

DATE=$(date +%Y%m%d)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STEERING="${PROJECT_ROOT}/.steering/${DATE}-${FEATURE}"

mkdir -p "$STEERING"
touch "$STEERING"/{requirements.md,design.md,tasklist.md,issues.md,handoff.md,feedback.md}

PLANNER_PROMPT="$(cat "${PROJECT_ROOT}/.codex/agents/planner.md")"

echo "=== Planner 起動: ${FEATURE} ==="
echo "ステアリングディレクトリ: ${STEERING}"

codex --approval-mode full-auto "${PLANNER_PROMPT}

---
## 実行タスク

機能名: ${FEATURE}
ステアリングディレクトリ: ${STEERING}
プロジェクトルート: ${PROJECT_ROOT}

上記の指示に従って、ステアリングディレクトリにファイルを作成してください。
テンプレートは ${PROJECT_ROOT}/.codex/templates/steering/ にあります。"

echo "=== Planner 完了 ==="
echo "作成されたファイル:"
ls -la "$STEERING"
