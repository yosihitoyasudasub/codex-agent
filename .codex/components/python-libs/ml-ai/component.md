# Python ライブラリ: ML・AI

## 概要
機械学習・AI 推論のためのライブラリ群。
FastAPI バックエンドに追加される。

## ライブラリ
- PyTorch — 深層学習フレームワーク
- Transformers (HuggingFace) — 事前学習モデルの活用
- LangChain — LLM アプリケーションフレームワーク

## 前提
Backend: FastAPI を選択していること

## 注意
PyTorch は GPU を使用する場合、Dockerfile の base image を
`python:3.12-slim` → `pytorch/pytorch:2.x-cuda12.x-cudnn9-runtime` に変更すること
