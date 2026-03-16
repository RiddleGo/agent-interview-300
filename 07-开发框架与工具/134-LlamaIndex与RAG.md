# 第 134 题：LlamaIndex 与 RAG 开发

## 题目

如何用 LlamaIndex 搭建 RAG 流水线？

---

## 一、基本流程

1. **加载文档**：用 `SimpleDirectoryReader`、`UnstructuredReader` 等**加载** PDF、网页等，得到 `Document` 列表。  
2. **解析与分块**：通过 **NodeParser**（如 `SentenceSplitter`）将 Document 切成 **Node**；可配置 chunk_size、overlap 等。  
3. **建索引**：用 **VectorStoreIndex.from_documents(nodes)** 或先建 `VectorStore` 再建 Index；内部会对 Node 做 embedding 并写入向量库。  
4. **查询引擎**：`index.as_query_engine()` 得到默认的 **QueryEngine**（Retriever + ResponseSynthesizer）；或自定义 **Retriever**（如 top_k、相似度阈值）与 **ResponseSynthesizer**（如 response_mode）再组合。  
5. **查询**：`engine.query("用户问题")`，内部执行检索 → 组装 prompt → LLM 生成 → 返回回答与可选来源。

---

## 二、可定制点

- **Embedding 与向量库**：通过 **ServiceContext** 设置 `embed_model`；Index 可指定 **VectorStore**（Chroma、Pinecone、Qdrant 等）。  
- **Retriever**：`index.as_retriever(similarity_top_k=..., ...)` 得到 Retriever；可替换为 **Custom Retriever**（多路、重排、过滤）。  
- **Response 模式**：如 `compact`（拼成一块）、`tree_summarize`（分层汇总）、`no_text`（仅检索不生成）等。  
- **Prompt**：在 **ServiceContext** 或 QueryEngine 层覆盖 `response_synthesizer.service_context` 的 default prompts，定制“如何用上下文回答”的指令。

---

## 三、与评估、可观测

- **Evaluation**：可用 LlamaIndex 的 **FaithfulnessEvaluator**、**RelevancyEvaluator** 等对 query 与 response 做评估。  
- **Observability**：集成 **LlamaIndex 的 callback** 或 **LangSmith** 等，记录检索到的节点、prompt、token 与延迟。

---

## 四、小结与面试要点

**小结**：LlamaIndex RAG = 加载文档 → 分块成 Node → 建 VectorStoreIndex → as_query_engine → query；可定制 Embedding、向量库、Retriever、Response 模式与 Prompt；支持评估与可观测。

**面试要点**：能说清“Document → Node → Index → QueryEngine → query”；能举 1～2 个可定制点（Retriever、response_mode）；评估与 callback 可顺带提及。

---

## 记忆要点

1. 流程：Document → NodeParser → VectorStoreIndex → QueryEngine → query。  
2. 定制：Embedding、VectorStore、Retriever、response_mode、Prompt。  
3. 评估与可观测：Faithfulness/Relevancy、callback 与 trace。

---

*上一篇：[第 133 题 - LlamaIndex 概述](./133-LlamaIndex概述.md)*  
*下一篇：[第 135 题 - 向量库集成](./135-向量库集成.md)*
