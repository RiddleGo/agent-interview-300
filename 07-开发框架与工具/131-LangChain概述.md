# 第 131 题：LangChain 概述与核心概念

## 题目

简述 LangChain 的核心概念与适用场景。

---

## 一、LangChain 是什么

**LangChain** 是一个用于**构建 LLM 应用**的开源框架，提供**组件**（模型、提示、检索、工具等）与**组合方式**（链、Agent、工作流），便于快速搭建对话、RAG、Agent 等应用，并统一对接多种 LLM、向量库与工具。

---

## 二、核心概念

- **Model I/O**：统一封装 **LLM**（如 OpenAI、开源模型）与 **Prompt**（模板、示例、输出解析）；通过 `ChatModel`、`BaseMessage`、`PromptTemplate` 等抽象，便于换模型与改提示。  
- **Retrieval**：**文档加载、分块、向量化、检索**等 RAG 组件；与向量库（Chroma、Pinecone、FAISS 等）集成，组成检索链。  
- **Chains**：将多步**串联**成链（如 prompt → LLM → 解析）；`LCEL`（LangChain Expression Language）用 `|` 组合 runnable，支持流式与批处理。  
- **Agents**：**根据输入决定调用哪些工具、如何组合**；通过 `AgentExecutor`、`create_react_agent` 等，结合工具与 ReAct 等策略实现“推理+工具”的 Agent。  
- **Tools**：将函数、API、检索等封装为 **Tool**，供 Agent 或链调用；统一接口（name、description、func）。  
- **Memory**：**对话历史、缓冲、摘要**等记忆组件，用于多轮对话的上下文管理。

---

## 三、适用场景

- **快速原型**：用少量代码搭出 RAG、Agent、对话流。  
- **可组合流水线**：链与 Agent 可嵌套、复用；便于做 A/B、换模型与加步骤。  
- **多后端统一**：同一套代码可切换 OpenAI、本地模型、不同向量库；便于迁移与多云。  
- **可观测**：与 **LangSmith** 等集成，做 trace、评估与调试。

---

## 四、小结与面试要点

**小结**：LangChain 提供 Model I/O、Retrieval、Chains、Agents、Tools、Memory 等组件与组合方式；适合快速构建 RAG、Agent 与对话应用，并统一多后端与可观测。

**面试要点**：能说出 3～4 个核心概念（链、Agent、工具、记忆）；LCEL 与 LangSmith 可顺带提及；适用场景为原型、流水线、多后端。

---

## 记忆要点

1. 核心：Model I/O、Retrieval、Chains、Agents、Tools、Memory。  
2. 链 = 多步串联；Agent = 推理+工具选择；LCEL 用 `|` 组合。  
3. 适用：快速原型、可组合流水线、多后端、可观测（LangSmith）。

---

*上一篇：[第 130 题 - RAG 生产实践与部署](../06-RAG与知识增强/130-RAG生产实践与部署.md)*  
*下一篇：[第 132 题 - LangChain 与 Agent](./132-LangChain与Agent.md)*
