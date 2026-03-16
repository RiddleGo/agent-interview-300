# 第 148 题：开源 Agent 框架对比

## 题目

LangChain、LlamaIndex、CrewAI、AutoGen 等开源 Agent 框架的对比与选型。

---

## 一、LangChain

- **侧重**：通用 **链与 Agent** 编排；Model I/O、Tools、Memory、Retrieval 组件全；**LCEL** 与 **LangGraph** 支持复杂工作流。  
- **适合**：快速原型、复杂多步逻辑、需统一多后端（LLM、向量库、工具）；生态与 LangSmith 成熟。  
- **Agent**：ReAct、Function Calling、自定义 Agent 类型；与 RAG 结合方便。

---

## 二、LlamaIndex

- **侧重**：**数据与 RAG**；Index、Query Engine、Retriever、Response Synthesizer 抽象细；与向量库、图谱集成深。  
- **适合**：以检索与知识库为核心的应用；需细粒度控制分块、检索与生成时选 LlamaIndex；也支持 Agent（工具可为查询引擎）。  
- **与 LangChain**：可组合使用（如 LlamaIndex 做检索、LangChain 做链与 Agent）。

---

## 三、CrewAI

- **侧重**：**多角色协作**；Role（目标、背景）+ Task（执行者、依赖）+ Crew（Kickoff 执行）；配置化、流水线式。  
- **适合**：固定分工的多 Agent 流水线（如调研→写作→审核）；YAML/代码配置清晰。  
- **与 LangChain**：偏“编排与角色”，底层可接 LangChain 的 LLM/Tool。

---

## 四、AutoGen

- **侧重**：**多 Agent 对话与群聊**；ConversableAgent、GroupChat、Human-in-the-loop；消息驱动、灵活讨论。  
- **适合**：多轮讨论、辩论、人机协作、代码评审；不强调固定流水线而强调对话形态。  
- **与 LangChain**：可接 LangChain 的 LLM；形态上偏“对话”而非“任务链”。

---

## 五、选型简要

| 需求 | 可考虑 |
|------|--------|
| 通用链与 Agent、多后端统一 | LangChain |
| RAG 与数据为中心 | LlamaIndex |
| 多角色流水线、配置化 | CrewAI |
| 多 Agent 对话、人机协作 | AutoGen |

可**组合**：如 LangChain 做单 Agent 与工具、CrewAI 做多角色编排；LlamaIndex 做 RAG、LangChain 做链。

---

## 六、小结与面试要点

**小结**：LangChain 通用链与 Agent；LlamaIndex 数据与 RAG；CrewAI 多角色流水线；AutoGen 多 Agent 对话与人机协作；按“要流水线还是要对话、要 RAG 还是要通用链”选型，可组合使用。

**面试要点**：能一句话概括各框架侧重；能说出 2～3 个选型维度与对应推荐；组合使用要能举例。

---

## 记忆要点

1. LangChain：通用链与 Agent、多后端；LlamaIndex：RAG 与数据。  
2. CrewAI：多角色流水线；AutoGen：多 Agent 对话与人机协作。  
3. 选型看流水线 vs 对话、RAG vs 通用链；可组合。

---

*上一篇：[第 147 题 - 版本与实验管理](./147-版本与实验管理.md)*  
*下一篇：[第 149 题 - 低代码平台](./149-低代码平台.md)*
