#!/bin/bash
# Evaluator: 独立コンテキストでスプリント検証を実行する
# 使い方: bash scripts/codex-evaluate.sh [steering-dir絶対パス] [sprint番号] "[変更ファイル一覧]"

set -e

STEERING="$1"
SPRINT="$2"
FILES="$3"

if [ -z "$STEERING" ] || [ -z "$SPRINT" ]; then
  echo "Usage: bash scripts/codex-evaluate.sh [steering-dir] [sprint番号] \"[変更ファイル一覧]\"" >&2
  echo "Example: bash scripts/codex-evaluate.sh \"\$(pwd)/.steering/20240101-auth\" 1 \"src/auth.ts src/auth.test.ts\"" >&2
  exit 1
fi

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EVALUATOR_PROMPT="$(cat "${PROJECT_ROOT}/.codex/agents/evaluator.md")"

echo "=== Evaluator 起動: スプリント${SPRINT} ==="
echo "ステアリングディレクトリ: ${STEERING}"
echo "変更ファイル: ${FILES}"

codex --approval-mode full-auto "${EVALUATOR_PROMPT}

---
## 検証タスク

ステアリングディレクトリ: ${STEERING}
検証対象スプリント: ${SPRINT}
変更ファイル: ${FILES}
プロジェクトルート: ${PROJECT_ROOT}

スプリント契約（tasklist.md の検証ゲート）に基づき検証し、feedback.md に結果を記録してください。
静的検証コマンドも実行してください: npx tsc --noEmit && npx jest && npm run lint"

echo "=== Evaluator 完了 ==="
echo "フィードバック:"
cat "${STEERING}/feedback.md" 2>/dev/null || echo "(feedback.md が空です)"
