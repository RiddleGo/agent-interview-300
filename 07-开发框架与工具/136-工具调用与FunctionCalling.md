# 第 136 题：工具调用与 Function Calling

## 题目

解释 LLM 的 Function Calling（工具调用）机制，以及在 Agent 框架中如何接入。

---

## 一、Function Calling 是什么

**Function Calling** 指模型**不直接输出自然语言答案**，而是输出**结构化调用请求**：函数名 + 参数（JSON）。由**调用方**根据该请求执行真实函数/API，再把结果以“工具返回”形式送回模型，模型再基于结果生成下一句或最终回答。这样**工具边界清晰**、**参数可校验**、**无需从自然语言里解析**函数与参数，减少解析错误与滥用。

---

## 二、流程简述

1. **定义工具**：声明**函数名、描述、参数 schema**（JSON Schema），如 `name`, `description`, `parameters`（type、properties、required）。  
2. **请求**：将**工具定义**与**用户消息**一起发给模型；模型可选地返回 `tool_calls`（id、name、arguments）。  
3. **执行**：调用方根据 `tool_calls` 解析出函数名与参数，**执行**对应函数，得到结果。  
4. **回传**：将结果以 **tool message**（role=tool, content=结果, tool_call_id=…）追加到对话，再请求模型；模型可继续生成或再发起 tool_calls，直到输出最终回答。

---

## 三、在框架中的接入

- **LangChain**：支持 **bind_tools(tools)** 将工具定义绑到 LLM；**Agent** 使用支持 tool_choice 的模型时，可直接用模型返回的 tool_calls 驱动执行，无需手写 ReAct 解析。  
- **LlamaIndex**：Agent 可配置 **Function Calling** 作为工具调用方式；Tool 的 schema 可由框架从函数签名与 docstring 生成或手写。  
- **OpenAI API**：`tools` 参数传工具列表，`tool_choice` 控制是否强制用工具；返回的 `choices[0].message.tool_calls` 即结构化调用。

---

## 四、小结与面试要点

**小结**：Function Calling = 模型输出结构化“函数名+参数”，由调用方执行后回传结果；流程为定义 schema → 请求带工具 → 解析 tool_calls → 执行 → 回传 tool message；框架通过 bind_tools 与 Agent 集成。

**面试要点**：能说清“模型输出 tool_calls、执行、回传 tool message”的闭环；与 ReAct 解析的对比（结构化 vs 自然语言解析）；在 LangChain/LlamaIndex 中的接入方式要能举一二。

---

## 记忆要点

1. 机制：模型输出函数名+参数（JSON），调用方执行并回传结果。  
2. 流程：定义 schema → 请求带 tools → tool_calls → 执行 → tool message 回传。  
3. 优势：边界清晰、可校验、无需从文本解析；框架通过 bind_tools 接入。

---

*上一篇：[第 135 题 - 向量库集成](./135-向量库集成.md)*  
*下一篇：[第 137 题 - 链与工作流](./137-链与工作流.md)*
