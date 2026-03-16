# 第 132 题：LangChain 与 Agent 开发

## 题目

如何用 LangChain 开发具备工具调用能力的 Agent？

---

## 一、Agent 组成

LangChain 中 Agent 通常由以下部分组成：  
- **LLM**：负责推理与生成“下一步动作”（如 thought、action、action_input）。  
- **Tools**：可供调用的工具列表（函数、API、检索等），每个 Tool 有 name、description、func。  
- **Prompt**：系统与用户消息中约定** ReAct 等格式**（thought/action/observation），并注入工具描述。  
- **Agent 逻辑**：解析 LLM 输出，若为“调用工具”则执行工具并得到 observation，再拼回 prompt 继续生成，直到输出最终答案。  
- **AgentExecutor**：驱动“LLM → 解析 → 工具执行 → 再 LLM”的循环，处理异常、最大步数、early stop 等。

---

## 二、开发步骤简述

1. **定义 Tools**：用 `@tool` 或 `Tool(name=..., func=..., description=...)` 封装函数；description 要写清用途与参数，供 LLM 选择。  
2. **组装 Prompt**：使用 `create_react_prompt` 或自定义模板，包含“可用工具列表”与“格式说明”（thought/action/observation）。  
3. **创建 Agent**：`create_react_agent(llm, tools, prompt)` 得到 runnable；再包一层 `AgentExecutor(agent, tools, ...)` 处理执行与循环。  
4. **调用**：`executor.invoke({"input": "用户问题"})`，内部会多轮 LLM+工具直到结束。  
5. **可选**：加入 **Memory**（如 `ConversationBufferWindowMemory`）注入历史，实现多轮对话 Agent。

---

## 三、注意点

- **工具描述**：清晰、简洁的描述能显著提升工具选择准确率；可加示例。  
- **解析稳定性**：LLM 输出可能格式不全或错误，需**解析容错**（如正则、重试、fallback）；必要时用支持 **function calling** 的模型减少解析问题。  
- **步数与安全**：设置 **max_iterations** 与 **early_stopping**，避免死循环；对工具做**权限与参数校验**，防止越权与注入。

---

## 四、小结与面试要点

**小结**：LangChain Agent = LLM + Tools + ReAct 类 Prompt + 解析与执行循环；开发步骤为定义工具、组装 prompt、创建 agent 与 executor、可选加记忆；需注意工具描述、解析稳定性与步数安全。

**面试要点**：能说清 Agent 的组成与执行流程；工具描述与解析的重要性要提到；可提及 function calling 与 Memory 的接入。

---

## 记忆要点

1. 组成：LLM、Tools、Prompt（ReAct）、解析、Executor。  
2. 步骤：定义 Tool → 组装 Prompt → create_react_agent → AgentExecutor → invoke。  
3. 注意：工具描述、解析容错、步数限制与安全。

---

*上一篇：[第 131 题 - LangChain 概述](./131-LangChain概述.md)*  
*下一篇：[第 133 题 - LlamaIndex 概述](./133-LlamaIndex概述.md)*
