# 新機能の追加（3エージェント・ハーネス構成）

このワークフローは企画・実装・検証を独立したプロセスに分離し、品質の客観性を確保する。

```
Planner（別プロセス） → Generator（このセッション） ⇄ Evaluator（別プロセス）
```

- **Planner**: `scripts/codex-plan.sh` で起動。ステアリングファイルを作成
- **Generator**: このセッションがスプリント単位で実装
- **Evaluator**: `scripts/codex-evaluate.sh` で起動。各スプリントを独立コンテキストで検証

---

## ステップ1: 準備

1. 機能名と日付を確定する:
   - 機能名: `[引数で与えられた機能名]`
   - 日付: `$(date +%Y%m%d)`
   - ステアリングディレクトリ: `.steering/[日付]-[機能名]/`
2. ステアリングディレクトリと空ファイルを作成:
   ```bash
   DATE=$(date +%Y%m%d)
   STEERING=".steering/${DATE}-[機能名]"
   mkdir -p "$STEERING"
   touch "$STEERING"/{requirements.md,design.md,tasklist.md,issues.md,handoff.md,feedback.md}
   ```

## ステップ2: 企画フェーズ（Planner 起動）

```bash
bash scripts/codex-plan.sh [機能名]
```

Planner が完了したら:
1. 作成されたステアリングファイルを読み込む
2. `issues.md` に致命的な問題がないか確認する
3. 致命的な問題がある場合 → ユーザーに報告し承認を得る
4. `issues.md` 対策を `docs/` 配下の永続ドキュメントに反映する
5. `tasklist.md` に以下を追加して完了マークを付ける:
   ```
   ## フェーズ0: issues.md 永続ドキュメント反映
   - [x] issues.md の全対策を docs/ に反映完了
   ```

**このステップが完了したら、ただちにステップ3に進むこと。**

## ステップ3: 実装フェーズ（Generator = このセッション）

### スプリントループ

**各スプリントの開始時:**
1. `handoff.md` と `tasklist.md` を読み込む
2. `feedback.md` がある場合は前回の差し戻し内容を確認する
3. 次のスプリントのタスクを特定する

**各タスクの実装:**
- タスク開始時: `tasklist.md` の `[ ]` → `[x]` に即時更新
- `AGENTS.md` のコーディング規約を遵守
- タスクが大きすぎる場合はサブタスクに分割して `tasklist.md` に追加
- 技術的理由でタスクが不要な場合のみ、理由を明記してスキップ

**スプリントの全タスクが `[x]` になったら → ステップ4（検証フェーズ）へ**

### handoff.md の更新
各スプリント開始前に更新:
- 前スプリントの完了状態サマリ
- 残存する問題・注意点
- 次スプリントで着手すべき内容

## ステップ4: 検証フェーズ（Evaluator 起動）

各スプリント完了時に実行:

```bash
bash scripts/codex-evaluate.sh \
  "$(pwd)/.steering/[日付]-[機能名]" \
  [スプリント番号] \
  "[変更ファイルのパス一覧（スペース区切り）]"
```

### Evaluator の結果に基づく分岐

- **合格**: 次のスプリントへ進む（ステップ3に戻る）
- **差し戻し**:
  1. `feedback.md` の修正指示を読む
  2. 指摘事項を修正する
  3. 再度 `codex-evaluate.sh` を実行して再検証
  4. 合格するまで繰り返す（最大3回。3回不合格の場合はユーザーに報告）

全スプリントの検証ゲートが合格したら → ステップ5へ。

## ステップ5: 最終検証

1. **tasklist.md の全タスク完了確認**:
   - 未完了タスク（`[ ]`）がないことを確認
   - あればステップ3に戻って実装

2. **自動テストの実行**:
   ```bash
   npx tsc --noEmit
   npx jest
   npm run lint
   ```
   エラーがあれば修正して再実行。

3. **永続ドキュメントへの反映** (`docs/` との乖離を確認・更新):
   - 関数・インターフェース変更 → `docs/functional-design.md`
   - ファイル追加・削除 → `docs/architecture.md`, `docs/repository-structure.md`
   - UI変更 → `docs/screen-design.md`
   - 新機能追加 → `docs/product-requirements.md`
   - 用語変更 → `docs/glossary.md`

## ステップ6: 振り返り

`tasklist.md` の振り返りセクションに記録:
- 実装完了日
- 計画と実績の差分
- 学んだこと
- 次回への改善提案
- **ハーネスへのフィードバック**:
  - Planner の計画精度（要件・タスクの過不足）
  - Evaluator の検証精度（差し戻し回数、有効だった指摘）
  - スプリント粒度（適切だったか）
  - handoff.md の有用性

## 完了条件

- [ ] Planner がステアリングファイルを作成済み
- [ ] issues.md の致命的問題が解決済み（フェーズ0ゲート通過）
- [ ] 全スプリントの実装が完了（tasklist.md の全タスクが `[x]`）
- [ ] 全スプリントの検証ゲートを Evaluator が合格判定
- [ ] `tsc`, `jest`, `lint` の全コマンドがエラーなし
- [ ] 永続ドキュメントが最新状態に更新済み
- [ ] 振り返りが tasklist.md に記録済み

この完了条件を満たすまで、自律的に思考し、問題解決を行い、作業を継続すること。
