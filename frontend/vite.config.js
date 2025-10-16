import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0',           // 允许外部访问
    port: 5173,                // 默认端口，可以改
    strictPort: true,          // 端口被占用时报错
    cors: true,                // 允许跨域
    hmr: {
      host: 'mirrorself.zdzd.xyz',  // 热更新使用你的域名
    }
  }
})
