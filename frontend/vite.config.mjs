import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, '/src'),
    },
  },
  server: {
    host: '0.0.0.0',           // 允许外部访问
    port: 5173,                // 默认端口，可以改
    strictPort: true,          // 端口被占用时报错
    cors: true,                // 允许跨域
    allowedHosts: ['.zdzd.xyz'], // 允许的域名
    hmr: {
      host: undefined
    },
    proxy: {
      '^/(api|db)': {
        target: 'http://localhost:3001', // 代理目标地址
        changeOrigin: true,
      }
    }
  }
})
