# 第 133 题：LlamaIndex 概述与核心概念

## 题目

简述 LlamaIndex 的核心概念与适用场景。

---

## 一、LlamaIndex 是什么

**LlamaIndex** 是一个面向**数据与检索**的 LLM 应用框架，侧重**将外部数据（文档、数据库、API）接入 LLM**，提供索引、检索、查询引擎与可选 Agent，适合 RAG、知识问答与数据驱动对话。

---

## 二、核心概念

- **Index（索引）**：对**文档**做解析、分块、向量化（及可选图谱等）后建成的可检索结构；如 `VectorStoreIndex`、`KnowledgeGraphIndex`；索引是“数据→可查询”的桥梁。  
- **Query Engine（查询引擎）**：对 **query** 做检索（与可选重排）、组装上下文、调用 LLM 生成回答；`index.as_query_engine()` 得到引擎，`engine.query("...")` 即一次 RAG 查询。  
- **Retriever**：从索引中**召回**相关节点（chunk）；可替换为自定义 Retriever（如多路、重排），再与 Response Synthesizer 组合。  
- **Response Synthesizer**：将检索到的节点与 query 组装成 prompt，调 LLM 生成回答；支持多种模式（如 compact、tree_summarize）。  
- **Nodes 与 Documents**：**Document** 为原始文档，**Node** 为分块后的节点（带文本与元数据）；索引在 Node 级别建向量等。  
- **Agent**：LlamaIndex 也支持 **ReAct Agent**、**OpenAI Function Calling** 等，可把查询引擎、工具封装为 Tool，组成数据感知的 Agent。

---

## 三、与 LangChain 的侧重

- **LlamaIndex**：以**索引与查询**为中心，RAG 与数据接入的抽象更细（Retriever、Synthesizer、多种 Index）；适合“数据第一”的应用。  
- **LangChain**：以**链与 Agent** 为中心，组件更泛化；适合复杂工作流与多步推理。  
二者可结合使用（如用 LlamaIndex 做检索、LangChain 做链与 Agent）。

---

## 四、小结与面试要点

**小结**：LlamaIndex 以索引、查询引擎、Retriever、Response Synthesizer 为核心，侧重数据接入与 RAG；适合知识问答与数据驱动应用；与 LangChain 可互补。

**面试要点**：能说出 Index、Query Engine、Retriever、Synthesizer；与 LangChain 的差异要能概括（数据/索引中心 vs 链/Agent 中心）。

---

## 记忆要点

1. 核心：Index、Query Engine、Retriever、Response Synthesizer；Nodes/Documents。  
2. 流程：Document → Index → Retriever + Synthesizer → Query Engine → 回答。  
3. 侧重：数据与 RAG；与 LangChain 可互补。

---

*上一篇：[第 132 题 - LangChain 与 Agent](./132-LangChain与Agent.md)*  
*下一篇：[第 134 题 - LlamaIndex 与 RAG](./134-LlamaIndex与RAG.md)*
