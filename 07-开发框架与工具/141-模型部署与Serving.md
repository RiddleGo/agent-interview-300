# 第 141 题：模型部署与 Serving

## 题目

LLM 与 Embedding 模型如何部署与对外提供 Serving 接口？

---

## 一、部署形态

- **API 服务**：模型以 **HTTP/gRPC** 对外提供**推理接口**（如 `/v1/chat/completions`、`/embeddings`）；客户端通过请求-响应调用。  
- **本地/自托管**：在自有 GPU 或服务器上**部署推理引擎**（如 vLLM、TGI、TensorRT-LLM），再封装为 API；数据与模型不出域，适合合规与成本优化。  
- **托管**：使用**云厂商或第三方**的 LLM/Embedding API（如 OpenAI、Azure、阿里云、Cohere）；免运维，按调用量计费。

---

## 二、推理引擎与 Serving

- **vLLM**：高吞吐、PagedAttention、连续批处理；支持 OpenAI 兼容 API；适合自托管高并发推理。  
- **TGI（Text Generation Inference）**：HuggingFace 的推理服务；支持张量并行、Flash Attention、流式；可部署为 HTTP 服务。  
- **TensorRT-LLM**：NVIDIA 生态，优化延迟与吞吐；需转换模型格式。  
- **OpenAI 兼容**：多数引擎提供 **OpenAI 兼容** 的 endpoint（如 `/v1/chat/completions`），便于应用层**无缝切换**自托管与 OpenAI。

---

## 三、Embedding 服务

- **单独部署**：Embedding 模型通常**单独**部署（如 sentence-transformers + FastAPI），或使用同一引擎的多模型能力；QPS 高时可多副本+负载均衡。  
- **批量**：支持 **batch** 请求可提高吞吐；注意单批大小与超时。

---

## 四、小结与面试要点

**小结**：部署形态有 API 服务、自托管与托管；自托管常用 vLLM、TGI、TensorRT-LLM 等推理引擎，并暴露 OpenAI 兼容接口；Embedding 可单独部署或与 LLM 同引擎；选型看延迟、吞吐、合规与成本。

**面试要点**：能说清自托管 vs 托管、常见推理引擎（vLLM、TGI）；OpenAI 兼容接口的意义；Embedding 的部署方式要能举一二。

---

## 记忆要点

1. 形态：API 服务、自托管（vLLM/TGI）、托管（云 API）。  
2. 引擎：vLLM 高吞吐、TGI 流式与并行、TensorRT-LLM 优化延迟。  
3. 兼容：OpenAI 兼容接口便于应用切换；Embedding 可单独部署。

---

*上一篇：[第 140 题 - 评估与测试](./140-评估与测试.md)*  
*下一篇：[第 142 题 - Docker 与容器化](./142-Docker与容器化.md)*
