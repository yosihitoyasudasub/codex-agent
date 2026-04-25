# ハーネス設計改善提案

## 背景

Anthropicが発表した2本のハーネス設計ベストプラクティスを参考に、現在の `.claude/` 配下の agents, commands, skills の改善を提案する。

### 参考文献

- [Effective harnesses for long-running agents (2025年11月)](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Harness design for long-running application development (2026年3月)](https://www.anthropic.com/engineering/harness-design-long-running-apps)

### Anthropicの主要な知見

- エージェントは自分の成果物を常に甘く評価する（生成と評価の分離が必須）
- コンテキストウィンドウが埋まると「コンテキスト不安」が発生し、作業を早く切り上げる
- 圧縮よりもリセット + 構造化ハンドオフが効果的
- ハーネスは仮説であり、新モデルが出たら再検証すべき
- 可能な限り単純な構成から始め、必要な時だけ複雑さを追加

---

## 現状の評価

現在のハーネスは永続ドキュメント、ステアリングファイル、サブエージェント、スキルの4層構成で堅実に構造化されている。しかし、Anthropicの知見と照合すると5つの構造的な課題がある。

---

## 課題と改善提案

### 1. 生成と評価が分離されていない

#### 現状の問題

`add-feature` コマンドは1つのコンテキストで企画→実装→検証をすべて実行する。Anthropicが警告する「エージェントは自分の成果物を甘く評価する」問題が発生しうる。

#### 改善案: 3エージェント構成への移行

```
現状:  Main Agent (Plan -> Implement -> Self-evaluate -> Validate)
                                           ^ ここが甘くなる

改善後: Planner Agent -> Generator Agent -> Evaluator Agent
        (企画専任)        (実装専任)          (検証専任)
                            ^                  |
                            +--- feedback -----+
```

#### 具体的な変更

- `agents/planner.md` を新設 -- ステアリングファイル作成に特化
- `agents/evaluator.md` を新設 -- 実際にアプリを操作して検証（Playwright MCP活用）
- 既存の `implementation-validator.md` を evaluator に統合・強化
- `add-feature` コマンドでこれら3エージェントを順次起動

---

### 2. コンテキストリセットの仕組みがない

#### 現状の問題

長い実装でコンテキストが埋まると「コンテキスト不安」が発生し、作業を早く切り上げようとする。現在は自動圧縮に依存。

#### 改善案: フェーズ間でのコンテキストリセット + 構造化ハンドオフ

#### 具体的な変更

- ステアリングファイルに `handoff.md` を追加 -- フェーズ間の状態引き継ぎ文書
- 各フェーズをサブエージェントとして実行することで、自然にコンテキストがリセットされる
- `tasklist.md` の各タスクに「完了状態のサマリ」欄を追加し、次のセッションが文脈なしでも再開できるようにする

---

### 3. Evaluatorが実際にアプリを動かしていない

#### 現状の問題

`implementation-validator` はコードを読んで静的に検証するのみ。Anthropicのベストプラクティスでは「ユーザーのようにアプリを操作して検証」が重要。

#### 改善案: Playwright MCP を活用した動的検証

#### 具体的な変更

- `agents/evaluator.md` にPlaywright MCPでの操作検証を組み込む
- 「スプリント契約」パターンの導入 -- 実装前にGeneratorとEvaluatorが評価基準を合意
- ステアリングの `requirements.md` に検証可能な受け入れ基準を必須化

---

### 4. フィードバックループが弱い

#### 現状の問題

Validatorの指摘→修正のサイクルが明示的に設計されていない。検証は「最後に1回」のみ。

#### 改善案: スプリント単位のフィードバックループ

```
Generator: タスク1-3を実装（1スプリント）
    |
    v
Evaluator: スプリント検証 -> フィードバック生成
    |
    v
Generator: フィードバック反映 -> 次のスプリント
    |
    v
Evaluator: 再検証...
```

#### 具体的な変更

- `tasklist.md` にスプリント区切りを導入
- `steering/SKILL.md` の実装モードにスプリントごとの検証ゲートを追加
- フィードバックは `feedback.md` としてステアリングディレクトリに蓄積

---

### 5. ハーネスの再検証メカニズムがない

#### 現状の問題

Anthropicの重要な原則「ハーネスは仮説であり、新モデルで再検証すべき」に対応する仕組みがない。

#### 改善案: ハーネス自体のメタ評価

#### 具体的な変更

- `commands/evaluate-harness.md` を新設 -- 直近N件の `.steering/` 実績を分析し、どのハーネスコンポーネントが効果的だったか/不要だったかをレポート
- 各ステアリングの振り返りに「ハーネスへのフィードバック」セクションを追加

---

## 変更の優先度

| 優先度 | 改善 | 理由 |
|---|---|---|
| P0 | 生成-評価の分離 | 品質への最大インパクト。Anthropicが最も強調 |
| P0 | フィードバックループ | 分離と組み合わせて初めて効果を発揮 |
| P1 | コンテキストリセット | 大規模機能で効果大。サブエージェント化で自然に実現 |
| P1 | 動的検証（Playwright） | 静的検証だけでは見つからないバグの検出 |
| P2 | ハーネス再検証 | 長期的な改善サイクルの基盤 |

---

## 影響範囲

### 新規作成

| ファイル | 種別 | 説明 |
|---|---|---|
| `agents/planner.md` | エージェント | 企画特化サブエージェント |
| `agents/evaluator.md` | エージェント | 動的検証サブエージェント |
| `commands/evaluate-harness.md` | コマンド | ハーネス有効性のメタ評価 |

### 変更

| ファイル | 変更内容 |
|---|---|
| `commands/add-feature.md` | 3エージェント順次起動 + スプリント構成に変更 |
| `skills/steering/SKILL.md` | スプリント検証ゲート追加、handoff.md対応 |
| `agents/implementation-validator.md` | evaluator.mdに統合後、廃止または縮小 |

### ステアリングファイル構成の変更

```
.steering/[YYYYMMDD]-[feature]/
  requirements.md   # 既存
  design.md          # 既存
  tasklist.md        # 既存（スプリント区切り追加）
  issues.md          # 既存
  handoff.md         # 新規: フェーズ間の状態引き継ぎ
  feedback.md        # 新規: Evaluatorからのフィードバック蓄積
```
