// src/api.js
import axios from "axios";

// 1. 创建 Axios 实例
const baseURL = window.location.origin;

const apiClient = axios.create({
    baseURL: baseURL,
    headers: {
        "Content-Type": "application/json",
    },
    timeout: 5000,
});

// 2. 封装 POST 请求方法
export async function postMeal(meal) {
    try {
        const response = await apiClient.post("/api/meal", { meal });
        return response.data; // 返回后端数据
    } catch (err) {
        console.error("postMeal failed:", err);
        throw err; // 可在主模块捕获
    }
}

