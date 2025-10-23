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

// 2. 发送餐品
export async function postMeal(meal) {
    try {
        const response = await apiClient.post("/api/meal", { meal });
        return response.data; // 返回后端数据
    } catch (err) {
        console.error("postMeal failed:", err);
        throw err; // 可在主模块捕获
    }
}

// 3. 发送“点击太多”消息
export async function postMsgSoMany() {
    post() || post() || post()
    async function post() {
        try {
            await apiClient.post("/api/msgsomany");
            return true;
        } catch (err) {
            console.error("postMsgSoMany failed:", err);
            return false;
        }
    }
}
